Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575Ab1ETQBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:01:33 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:46517 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab1ETQBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VCNe9S4I0Irn5LPDS3TaHt2E9UZ6Q9bZj5K+4UHs8Z5qnNMEXWhFRcvV6eNW4yOv2J
         s/ZzQhyiBYZdUkUW27dJMXc5ry4mTlnZAd8eCTYKRAXCPHUdYdYf+1nqF7HmbkmIIDlP
         Kfcaf2CD3QtIb3pXgkD7R09CRdpxpXp9SmJXE=
MIME-Version: 1.0
In-Reply-To: <20110520153346.GA1843@barrios-desktop>
References: <BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
 <BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com> <BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
 <BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com> <4DD5DC06.6010204@jp.fujitsu.com>
 <BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com> <BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
 <20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com> <20110520101120.GC11729@random.random>
 <BANLkTikAFMvpgHR2dopd+Nvjfyw_XT5=LA@mail.gmail.com> <20110520153346.GA1843@barrios-desktop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 20 May 2011 12:01:12 -0400
X-Google-Sender-Auth: x0kTDzS5p5ta2t3UgetLjtAHcpY
Message-ID: <BANLkTi=X+=Wh1MLs7Fc-v-OMtxAHbcPmxA@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 11:33 AM, Minchan Kim <minchan.kim@gmail.com> wrote:

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8bfd450..a5c01e9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1430,7 +1430,10 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
>
>        /* Check if we should syncronously wait for writeback */
>        if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
> +               unsigned long nr_active;
>                set_reclaim_mode(priority, sc, true);
> +               nr_active = clear_active_flags(&page_list, NULL);
> +               count_vm_events(PGDEACTIVATE, nr_active);
>                nr_reclaimed += shrink_page_list(&page_list, zone, sc);
>        }
>
> --

I'm now running that patch *without* the pgdat_balanced fix or the
need_resched check.  The VM_BUG_ON doesn't happen but I still get
incorrect OOM kills.

However, if I replace the check with:

	if (false &&should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {

then my system lags under bad memory pressure but recovers without
OOMs or oopses.

Is that expected?

--Andy

> 1.7.1
>
> --
> Kind regards,
> Minchan Kim
>
