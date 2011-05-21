Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1EUObs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:31:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52271 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1EUObq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LHsBOtFq415nfbR4lTl3Ip7L89b+KsG+d/xgogrBpARmoaMrSJFFuifNSsXL95XTwo
         saA9eO0WnRevouIBKHL0FkMF510QSiSyFSvcV+Xj9UxrnZ51h+9K+IQb6ljAsk20fMiu
         9/i1OKG6pZNnDgxeKzFvLUuX244bGL6st9My4=
MIME-Version: 1.0
In-Reply-To: <BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com>
References: <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
	<BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
	<4DD5DC06.6010204@jp.fujitsu.com>
	<BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
	<BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
	<20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520101120.GC11729@random.random>
	<BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com>
	<20110520153346.GA1843@barrios-desktop>
	<BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com>
	<20110520161934.GA2386@barrios-desktop>
	<BANLkTi=4C5YAxwAFWC6dsAPMR3xv6LP1hw@mail.gmail.com>
	<BANLkTimThVw7-PN6ypBBarqXJa1xxYA_Ow@mail.gmail.com>
Date: Sat, 21 May 2011 23:31:45 +0900
Message-ID: <BANLkTimfPXXcTamkR1kTgOu55iy14ybTpA@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 9:04 PM, KOSAKI Motohiro
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

Hi KOSAKI,
You're absolutely right.
I missed that so the problem should not happen. :(

-- 
Kind regards,
Minchan Kim
