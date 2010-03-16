Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0CPPKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:10:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:33783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0CPPJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:09:58 -0400
Message-ID: <4B9F9FD0.8040303@kernel.org>
Date: Wed, 17 Mar 2010 00:12:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: James Bottomley <James.Bottomley@suse.de>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <1268745897.21384.14.camel@mulgrave.site> <4B9F8E1A.2020608@kernel.org> <201003161538.27015.vda.linux@googlemail.com>
In-Reply-To: <201003161538.27015.vda.linux@googlemail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 15:09:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/16/2010 11:38 PM, Denys Vlasenko wrote:
> The "end of partition" is expected to be at the last head and sector.
> Of course this heuristic fails if there are more than one primary
> partition and they have differing last head and sector.
> 
> But on most "sanely" partitioned disks they are the same:
> 
> Disk /dev/sda: 255 heads, 63 sectors, 36481 cylinders
> 
> Nr AF  Hd Sec  Cyl  Hd Sec  Cyl      Start       Size ID
>  1 00   1   1    0 254  63  850         63   13671252 0b
>  2 80   0   1  851 254  63 1023   13671315  572395950 05
>  3 00   0   0    0   0   0    0          0          0 00
>  4 00   0   0    0   0   0    0          0          0 00
>  5 00   1   1  851 254  63  972         63    1959867 83
>  6 00   1   1  973 254  63 1023         63   31246362 83
>  7 00 254  63 1023 254  63 1023         63  195318207 83
>  8 00 254  63 1023 254  63 1023         63  343871262 83
>                    ^^^  ^^

C/H/S of 1023/254/63 is a special marker indicating the value there is
out-of-range.  It doesn't actually carry any information regarding the
geometry parameters other than that the matching LBA can't be
expressed within its range.  The end marker doesn't change according
to geometry parameters.  It's fixed at 0xfeffff.

> Which suggests another idea how to align a partition: since there is
> no requirement on the partition *start*, we don't have to start at
> head1,sector1 or head0,sector1

We don't have to align to cylinders either.

> In the example above, 1st partition might be modified to start at
> head1,sector2, IOW, LBA 64, thus making it 32k aligned.
> 
> As long as partition *ends* adhere to the convention of being
> exactly at last_head,last_sector, nothing should break.

That has almost nothing to do with compatibility.  Just let the
cylinder alignment go.  Anything remotely modern doesn't care about it
at all and anything older will puke way easier with custom geometry
massaging.  For those, we'll just have to stick with cylinder aligning
according to the BIOS supplied parameters.

Thanks.

-- 
tejun
