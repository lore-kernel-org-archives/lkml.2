Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab1DMKZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:25:11 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:45150 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087Ab1DMKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:25:08 -0400
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, Rob Landley <rlandley@parallels.com>,
        Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
In-Reply-To: <1301924863.8526.9.camel@castor.rsk>
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>
	 <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com>
	 <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com>
	 <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com>
	 <4D945976.8000401@fusionio.com> <20110331121100.GD3385@htj.dyndns.org>
	 <4D9474AA.4070402@fusionio.com> <4D947D12.6070505@rsk.demon.co.uk>
	 <4D947F29.5050203@fusionio.com> <1301577831.1984.2.camel@castor.rsk>
	 <4D9482BA.8080807@fusionio.com>  <1301582977.1984.7.camel@castor.rsk>
	 <1301924863.8526.9.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 11:25:00 +0100
Message-ID: <1302690300.1993.7.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 14:47 +0100, Richard Kennedy wrote:
> On Thu, 2011-03-31 at 15:49 +0100, Richard Kennedy wrote:
> > On Thu, 2011-03-31 at 15:33 +0200, Jens Axboe wrote:
> >[...]
> > > >>> Hi Jens,
> > > >>>
> > > >>> I'm seeing a problem with fio never completing when writing to 2 disks
> > > >>> simultaneously. In my test case I'm writing 2Gb to both a LVM volume & a
> > > >>> pata drive on x86_64 on a AMD X2. Could this be a related issue?
> > > >>>
> > > >>> I'm not getting anything reported in the log, lockup detection doesn't
> > > >>> report anything either. The write seems to have finished (the disk light
> > > >>> activity has stopped) and the cpu cores are both below 10% usage, but
> > > >>> fio never returns. The test does complete some times, but it seems to be
> > > >>> one 1 in 4.
> > > >>
> > > >> So when you say PATA, it's /dev/hdaX something as well?
> > > >>
> > > >>> I'm going to try tracing it and see if I can spot where it's stuck.
> > > >>
> > > >> Thanks, that would be nice.
> > > >>
> > > > The second drive is /dev/sdb1 mounted on /opt, both file systems are
> > > > ext4.
> > > 
> > > So probably not related. What does the fio job look like?
> > > 
> > fio job file --
> > [global]
> > pre_read=1
> > ioengine=mmap
> > 
> > [f1]
> > size=2g
> > rw=write
> > directory=/home/tests
> > 
> > [f2]
> > size=2g
> > rw=write
> > directory=/opt/tests
> > 
> > Fio gets run from a script that also collects stats but it's been
> > running without any problems up until 2.6.39-rc1.
> > 
> Hi Jens
> I've upgrade to the latest fio version in the git repo 1.51 and I'm
> still seeing this problem. 
> 
> Fio gets stuck after it writes the 100% complete message and strace on
> the processes shows this.
> 
> the controlling fio process :- 
>  ...
> [pid  8439] wait4(8442, 0x7fff848203ac, WNOHANG, NULL) = 0
> [pid  8439] nanosleep({0, 10000000}, NULL) = 0
> [pid  8439] wait4(8441, 0x7fff848203ac, WNOHANG, NULL) = 0
> [pid  8439] wait4(8442, 0x7fff848203ac, WNOHANG, NULL) = 0
> [pid  8439] nanosleep({0, 10000000}
> 
> & the 2 workers are both stopped here, strace shows only the one line
> for each process.
> 
> Process 8441 attached - interrupt to quit
> futex(0x7f9db76a802c, FUTEX_WAIT_PRIVATE, 2, NULL
> 
> 
> Process 8442 attached - interrupt to quit
> futex(0x7f9db76a802c, FUTEX_WAIT_PRIVATE, 2, NULL
> 
> How do I find out which futex it's waiting for? 
> Any ideas where I should look next ?
> 
> I can run the same test successfully on 2.6.38 so is it worth trying to
> bisect this ? 
> 
> thanks 
> Richard
> 
My problem has gone away in v2.6.39-rc3.
I've just finished bisecting it down to 6de9843dab3f, & that got
reverted in rc3, so no problem ;)

(The data corruption caused by that faulty commit was zeroing out the
shared mutexs in fio & the worker threads were getting stuck on the
writeout_mutex.)

regards
Richard




