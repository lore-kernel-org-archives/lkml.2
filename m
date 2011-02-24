Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1BXBSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:18:39 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:2679 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752830Ab1BXBSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:18:38 -0500
Message-ID: <4D65B1EA.4060801@draigBrady.com>
Date: Thu, 24 Feb 2011 01:18:34 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Linda A. Walsh" <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
References: <4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com> <4D654C2E.2000703@tlinx.org>
In-Reply-To: <4D654C2E.2000703@tlinx.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 18:04, Linda A. Walsh wrote:
> I tried using the 'iflag=fullblock' as you recommend and it made the
> problem
> 'consistent' with the output of 'mbuffer', i.e. it transfered less data
> and the truncation was consistent with a 512M divisor, indicating it was
> 'cat' default record output size that was causing the difference.

Right. That's expected as with 'fullblock', both mbuffer and dd
will read/write 512M at a time. Both will fail in the same
way when they try to write the odd sized chunk at the end.
This was only changed for dd in version coreutils 7.5
(where it reverts to a standard write for the last chunk)

> I've tried significantly shorter files and NOT had this problem
> (record size=64k, and 2 files oneat 64+57k). Both copied
> fine.
> Something to do with large file buffers.

Small blocks cause an issue on ext[34] at least.
I modified dd here to behave like yours and got:
$ truncate -s513 small
$ dd oflag=direct if=small of=small.out
./dd: writing `small.out': Invalid argument

> Of *SIGNIFICANT* note.  In trying to create an empty file of the size
> used, from scratch, using 'xfs_mkfile', I got an error:
> 
>>  xfs_mkfile 5776419696 testfile
> pwrite64: Invalid argument

Looks like that uses the same O_DIRECT write
method with the same issues?
You could try fallocate(1) which is newly available
in util-linux and might be supported by your xfs.

cheers,
Pádraig.

p.s. dd would if written today default to using fullblock.
For backwards and POSIX compat though we must keep
the current default behavior

p.p.s. There are situations were fullblock is required,
and I'll patch dd soon to auto apply that option when appropriate.
[io]flag=direct is one of those cases I think.

p.p.p.s coreutils 8.11 should have the oflag=nocache option
which will write to disk without using up your page cache,
and also avoiding O_DIRECT constraints.
