Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab2HXTEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:04:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53704 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2HXTEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:04:04 -0400
Message-ID: <1345835040.3443.22.camel@ayu>
Subject: Re: "Trapping" hard drive errors ( "ata***** failed command: READ
 FPDMA QUEUED")
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Mouse Dresden <mouse.the.lucky.dog@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 15:04:00 -0400
In-Reply-To: <CAOA0mo_-b3=mn5hKBE1S5s7_2tsnV42bFSe9v9Uj-Vmk4s54rQ@mail.gmail.com>
References: <CAOA0mo_-b3=mn5hKBE1S5s7_2tsnV42bFSe9v9Uj-Vmk4s54rQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 23:26 -0500, Mouse Dresden wrote:
> Hello I hope that this question is not to mundane.
> 
> A while ago I encountered this error message on a hard drive of mine.
> I managed to clean up the problem and run smartctl and the disk is
> clean, but such errors can be very problematic. I think one of the
> reasons is that the hard drive gets "bogs down" on the particular
> command and communication between the kernel and drive, other system
> calls time out. This generates a lot of spurious errors you have to
> eliminate.
> 
> I would like to create some basic tools to aid in diagnosing and
> repairing such problems. The main difficulty is "trapping" the error
> message. By this I mean terminating the call that is causing the
> error, causing the drive to abandon this particular command, and
> sending some sort of signal ( figurative and or literal ) to the
> process making the particular command, so I can trace it.
> 
> Can someone either describe the process, or if it is too long,
> recommend some reading describing it?
> 
> If it helps to know the detailed message, it can be found at:
> http://unix.stackexchange.com/questions/43681/kde-causes-read-fpdma-queued-error

This error has nothing to do with software (kde) configuration or
filesystem corruption. It is a hardware error. First of all, this:

sd 2:0:0:0: [sda]  Add. Sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sda, sector 326677146

means that your hard drive has a pending relocated sector (if you could
share the smartctl output, it would confirm this). Assuming that your
drive has spare area remaining (which it does, if smartctl says it's
happy), then simply overwriting the sector in question will cause the
drive to reallocate the sector and fix the error.

You can use the 'hdparm --write-sector' command to do this - but read
all the warnings and backup important data first.

The reason for the delay/timeouts that you're seeing is that typical
consumer drives will attempt to retry reads many times for up to 10
seconds (or longer!) before returning an error to the operating system.
In the mean time, there is no way for the linux kernel to cancel the
command. It can only wait it out.

Often times, errors like this are signs that your drive is close to
failing - not /always/, but often. If manually overwriting the sector in
question doesn't help, you should probably look into replacing the
drive.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

