Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0GWO46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:56:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab0GWO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:56:57 -0400
Date: Fri, 23 Jul 2010 16:56:31 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100723145631.GA8844@fancy-poultry.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723141303.GB13104@redhat.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:q+jftrjBm6wcMKpcut8jylKgUkdeFQ98m7sbsyipsCp
 LhKOkaukbSTIRYO9Y3lGPPGmqmBHyRTAaFBJZMeiH5xTCYKiBL
 34xqO0JSg4xQ0Fys8XyMMdvpZpi9Kf8S+uFdjKFkS+zjBgKcX1
 R8jZbIYn6HzDILxudiPkp8pmgsCFtKry3YQReqK9qkZG8nmp18
 gkhJD5vVYbG1G0rsjeKuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2010, Vivek Goyal wrote: 

> Thanks for some testing Heinz. I am assuming you are not using cgroups
> and blkio controller.

Not at all.

> In that case, you are seeing improvements probably due to first patch
> where we don't idle on service tree if slice_idle=0. Hence we cut down on
> overall idling and can see throughput incrase.

Hmm, in any case it's not getting worse by setting slice_idle to 8. 

My main motivation to test your patches was that I thought 
the other way 'round, and was just curious on how this patchset 
will affect machines which are NOT a high end server/storage system :-) 

> What kind of configuration these 3 disks are on your system? Some Hardare
> RAID or software RAID ?

Just 3 SATA disks plugged into the onboard controller, no RAID or whatsoever.

I used fs_mark for testing:
"fs_mark  -S  1  -D  10000  -N  100000  -d  /home/htd/fsmark/test  -s 65536  -t  1  -w  4096  -F"

These are the results with plain cfq (2.6.35-rc6) and the settings which
gave the best speed/throughput on my machine:

low_latency = 0
slice_idle = 4
quantum = 32

Setting slice_idle to 0 didn't improve anything, I tried this before.

FSUse%        Count         Size    Files/sec     App Overhead
    27         1000        65536        360.3            34133
    27         2000        65536        384.4            34657
    27         3000        65536        401.1            32994
    27         4000        65536        394.3            33781
    27         5000        65536        406.8            32569
    27         6000        65536        401.9            34001
    27         7000        65536        374.5            33192
    27         8000        65536        398.3            32839
    27         9000        65536        405.2            34110
    27        10000        65536        398.9            33887
    27        11000        65536        402.3            34111
    27        12000        65536        398.1            33652
    27        13000        65536        412.9            32443
    27        14000        65536        408.1            32197


And this is after applying your patchset, with your settings
(and slice_idle = 0):

FSUse%        Count         Size    Files/sec     App Overhead
    27         1000        65536        600.7            29579
    27         2000        65536        568.4            30650
    27         3000        65536        522.0            29171
    27         4000        65536        534.1            29751
    27         5000        65536        550.7            30168
    27         6000        65536        521.7            30158
    27         7000        65536        493.3            29211
    27         8000        65536        495.3            30183
    27         9000        65536        587.8            29881
    27        10000        65536        469.9            29602
    27        11000        65536        482.7            29557
    27        12000        65536        486.6            30700
    27        13000        65536        516.1            30243


There's some 2-3% further improvement on my system with these settings,
which after som fiddling turned out to give most performance here
(don't need the group settings, of course):

group_idle = 0
group_isolation = 0
low_latency = 1
quantum = 8
slice_idle = 8

Thanks,
Heinz.
