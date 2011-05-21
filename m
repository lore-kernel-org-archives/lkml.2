Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1EUMEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:04:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1EUMEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wHVpkvxXP8xrCBb9TqNzE1RyG2T5yAuRrux3+qVrjLYXKz0s9KcuGT9eWyGTQ/mcfV
         BcjYz+JTuCLAmO0S+tK6DCKjKZWFPQoxq2Sr4BtZ3RJY6/BmMOWOIoHe6/EKhXUtDoa0
         tjYD3xwS1PtvqDrrNTGu71Of+Hotcx9CG3uBc=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com>
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com> <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com> <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com> <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com> <20110520153346.GA1843@barrios-desktop>
 <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com> <20110520161934.GA2386@barrios-desktop>
 <BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sat, 21 May 2011 21:04:31 +0900
X-Google-Sender-Auth: z8C8k1yfkhjojsG5VargoqB_88I
Message-ID: <BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Andrew Lutomirski <luto@mit.edu>
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

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3f44b81..d1dabc9 100644
> @@ -1426,8 +1437,13 @@ shrink_inactive_list(unsigned long nr_to_scan,
> struct zone *zone,
>
>        /* Check if we should syncronously wait for writeback */
>        if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> +               unsigned long nr_active, old_nr_scanned;
>                set_reclaim_mode(priority, sc, true);
> +               nr_active = clear_active_flags(&page_list, NULL);
> +               count_vm_events(PGDEACTIVATE, nr_active);
> +               old_nr_scanned = sc->nr_scanned;
>                nr_reclaimed += shrink_page_list(&page_list, zone, sc);
> +               sc->nr_scanned = old_nr_scanned;
>        }
>
>        local_irq_disable();
>
> I just tested 2.6.38.6 with the attached patch.  It survived dirty_ram
> and test_mempressure without any problems other than slowness, but
> when I hit ctrl-c to stop test_mempressure, I got the attached oom.

Minchan,

I'm confused now.
If pages got SetPageActive(), should_reclaim_stall() should never return true.
Can you please explain which bad scenario was happen?

-----------------------------------------------------------------------------------------------------
static void reset_reclaim_mode(struct scan_control *sc)
{
        sc->reclaim_mode = RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC;
}

shrink_page_list()
{
 (snip)
 activate_locked:
                SetPageActive(page);
                pgactivate++;
                unlock_page(page);
                reset_reclaim_mode(sc);                  /// here
                list_add(&page->lru, &ret_pages);
        }
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
bool should_reclaim_stall()
{
 (snip)

        /* Only stall on lumpy reclaim */
        if (sc->reclaim_mode & RECLAIM_MODE_SINGLE)   /// and here
                return false;
-----------------------------------------------------------------------------------------------------
