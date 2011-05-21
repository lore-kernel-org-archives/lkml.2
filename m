Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1EUNfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 09:35:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50082 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1EUNfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 09:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XanyBtIzKyubXQU9U2HmC+3QS216XQJKs9QTdluy6BUPe5Ido19EyF1wHcS7FRKxtp
         cnQQDzNfHj4/FqQwNqxT0YJRAWDu68V1OXf6JK/xsB/gkMlzxK4c9M3cbtAbxOI23Iqa
         UVQ0Q0gmzkp6E5YvIW6l4zVK1yUVLNp8BiWHU=
MIME-Version: 1.0
In-Reply-To: <BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com>
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com> <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com> <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com> <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com> <20110520153346.GA1843@barrios-desktop>
 <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com> <20110520161934.GA2386@barrios-desktop>
 <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com> <BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 21 May 2011 09:34:47 -0400
X-Google-Sender-Auth: -Y1dW8X0TQNC_8lPXeKB-UNt_sQ
Message-ID: <BANLkTint+Qs+cO+wKUJGytnVY3X1bp+8rQ@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 8:04 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 3f44b81..d1dabc9 100644
>> @@ -1426,8 +1437,13 @@ shrink_inactive_list(unsigned long nr_to_scan,
>> struct zone *zone,
>>
>>        /* Check if we should syncronously wait for writeback */
>>        if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
>> +               unsigned long nr_active, old_nr_scanned;
>>                set_reclaim_mode(priority, sc, true);
>> +               nr_active = clear_active_flags(&page_list, NULL);
>> +               count_vm_events(PGDEACTIVATE, nr_active);
>> +               old_nr_scanned = sc->nr_scanned;
>>                nr_reclaimed += shrink_page_list(&page_list, zone, sc);
>> +               sc->nr_scanned = old_nr_scanned;
>>        }
>>
>>        local_irq_disable();
>>
>> I just tested 2.6.38.6 with the attached patch.  It survived dirty_ram
>> and test_mempressure without any problems other than slowness, but
>> when I hit ctrl-c to stop test_mempressure, I got the attached oom.
>
> Minchan,
>
> I'm confused now.
> If pages got SetPageActive(), should_reclaim_stall() should never return true.
> Can you please explain which bad scenario was happen?
>
> -----------------------------------------------------------------------------------------------------
> static void reset_reclaim_mode(struct scan_control *sc)
> {
>        sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
> }
>
> shrink_page_list()
> {
>  (snip)
>  activate_locked:
>                SetPageActive(page);
>                pgactivate++;
>                unlock_page(page);
>                reset_reclaim_mode(sc);                  /// here
>                list_add(&page->lru, &ret_pages);
>        }
> -----------------------------------------------------------------------------------------------------
>
>
> -----------------------------------------------------------------------------------------------------
> bool should_reclaim_stall()
> {
>  (snip)
>
>        /* Only stall on lumpy reclaim */
>        if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)   /// and here
>                return false;
> -----------------------------------------------------------------------------------------------------
>

I did some tracing and the oops happens from the second call to
shrink_page_list after should_reclaim_stall returns true and it hits
the same pages in the same order that the earlier call just finished
calling SetPageActive on.  I have *not* confirmed that the two calls
happened from the same call to shrink_inactive_list, but something's
certainly wrong in there.

This is very easy to reproduce on my laptop.

--Andy
