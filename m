Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0LXPYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:24:43 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:56009 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0LXPYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:24:42 -0500
Message-ID: <4D14BB36.1030304@msgid.tls.msk.ru>
Date: Fri, 24 Dec 2010 18:24:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>	<20101220190630.66084e1d@neptune.home>	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>	<20101222104306.GB30941@bitwizard.nl> <m3aajvz5na.fsf@intrepid.localdomain>
In-Reply-To: <m3aajvz5na.fsf@intrepid.localdomain>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.12.2010 16:01, Krzysztof Halasa wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
> 
>> ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
>> scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
>> sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931
>> GiB)
> 
> WD10EARS are "green" drives, 5400 rpm. They aren't designed exactly for
> speed. Never used them, though.

Oh..  The famous EARS drives.  I missed this info in the
start of the thread.

Now, after this info, the whole thread is quite moot.

The thing is, for these WD*EARS drivers, it is _vital_ to get
proper alignment of all partitions and operations.  They've
4Kb sectors physically but report 512bytes sectors to the OS.
It is _essential_ to ensure all partitions are aligned to the
4Kb sectors.  Be it LVM, raid-something, etc - each filesystem
must start at a 4kb boundary at least, or else you'll see
_dramatic_ write speed problems.

So.. check the whole storage stack and ensure proper alignment
everywhere.  In particular, check that your partitions are not
aligned to 63 sectors (512b), or starts at N+1 sector - the
most problematic mode for these drives.

And before anyone asks, no, these drives are actually very
good.  With proper alignment it works very fast for both
reads and writes, despite it being 5400RPM.  I have a 2Tb
drive from these series (WD20EARS) - despite numerous claims
that it does not work or works very slow with small files,
it's quite fast, faster than many prev-gen 7200 drives.

> No NCQ? Sil 3114 doesn't support of course. ICH7 (without letters)
> doesn't do AHCI either IIRC.

Yes, Sil 3114 does not support NCQ.  But these drives does not
have good NCQ implementation either - apparently the Read-Modify-Write
logic has eaten NCQ which were traditionally good in recent WD
drives.

>>   9 Power_On_Hours          0x0032   091   091   000    Old_age
>> Always       -       7189
>> 193 Load_Cycle_Count        0x0032   164   164   000    Old_age   Always
>>       -       109955
> 
> Hmm, some agressive power savings? May reduce performance significantly.
> I'd disable all this "green" crap first.

There's a utility (ms-dos based) to disable this feature for wd
ears drives, on their website.

>> Where it seems that WD simply says not to use these drives in a RAID.
> 
> That smells like "don't use them in any serious application".

No, this is about TLER.  The "desktop" drives like this will try
re-read data in case of error, and if that does not work the
raid code will most likely declare the drive's dead and kick
it off the array.  Drives which are supposed to work in RAID
config has configurable timeouts/retries, so that the RAID
code will be able to take care of read errors.

/mjt
