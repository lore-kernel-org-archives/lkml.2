Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2B1TiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:38:13 -0500
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:46666 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2B1TiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:38:12 -0500
Date: Tue, 28 Feb 2012 21:38:01 +0200 (EET)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Lee Duncan <lduncan@suse.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCSI, st: modify tape driver to allow writing immediate
 filemarks
In-Reply-To: <4F3405C9.3020606@suse.com>
Message-ID: <alpine.LNX.2.00.1202282126010.6053@kai.makisara.local>
References: <4F31CAC0.3010905@suse.com> <alpine.LNX.2.00.1202081910400.6087@kai.makisara.local> <4F3405C9.3020606@suse.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Lee Duncan wrote:

> On 02/08/2012 09:19 AM, Kai Makisara wrote:
> > On Tue, 7 Feb 2012, Lee Duncan wrote:
> > 
> >> Add an st module option st_nowait_eof which defaults to 0. Setting this
> >> option to 1 tells the st driver not to wait when writing a filemark, which
> >> can result in much faster times on streaming tape drives.
> >>
> >> Legacy applications cannot take advantage of the newer MTWEOFI ioctl, so this
> >> patch gives such applications the ability to write an immediate EOF using the
> >> normal MTWEOF ioctl if they set st_nowait_eof=1.
> >>
> >> Reference: https://bugzilla.novell.com/show_bug.cgi?id=688996
> >>
...
> > 
> > Anyway, I don't think this should be implemented as a pure module option. 
> > The standard semantics specify that MTWEOF is a synchronization point and 
> > this module option breaks that for all users.
> 
> The Standard specifies that writing a filemark (i.e. an EOF) is a
> synchronization point if and only if the data is being written in
> immediate mode. In other words, you are not supposed to set both
> immediate writes and immediate EOFs. This is why I didn't overload the
> already-existing "immediate" flag in the driver.
> 
Not quite what I mean. The following is from SSC-3 draft:
-
An IMMED bit of zero specifies the device server shall not return status 
until the write operation has completed. Any
buffered logical objects shall be written to the medium prior to 
completing the command.
-
So, what I mean is that all data in the drive buffer has been written to 
tape. This WRITE FILEMARKS command then returns any write errors that 
happen while the buffered data is written to tape. With immediate bit set, 
you may miss write errors.

> I will add a check to the driver to disallow immediate EOFs if immediate
> writes are requested.
> 
This may not be necessary. If someone wants to deliberately take risks, 
the driver should not prevent this ;-)

Kai
