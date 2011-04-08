Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1DHLiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 07:38:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43599 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab1DHLh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 07:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u8cukBEb+X20Bacy4VGzO4bA1zbhGbZ38CVbQKL4DSzCtb0JasV8Rj+u3nhtL6gFez
         1LrtgR0NkVIfSJQoKM42bjVc88hwaf1FTU+KUz1tgL857MihoaFoOzXP3nJR7xxD/T5m
         6X0dv4JioCDp/aXBM+iphaGT+Bq3JEI+uZiIw=
MIME-Version: 1.0
In-Reply-To: <20110406100620.GA4142@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
	<20110401154327.GA6593@mtj.dyndns.org>
	<20110405065129.GC2872@amit-x200.redhat.com>
	<20110406100620.GA4142@mtj.dyndns.org>
Date: Fri, 8 Apr 2011 12:37:56 +0100
Message-ID: <BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 11:06 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Apr 05, 2011 at 12:21:30PM +0530, Amit Shah wrote:
>> > But I don't think this is the correct place to do it.  The problem
>> > happens because block layer consumes the event but doesn't remember it
>> > when the time for revalidation comes.  It should be done by block
>> > layer, not sr.  Hmmm... looking at the code, the new disk event code
>> > should handle this correctly.  Was 2.6.38 showing the problem too?
>>
>> Yes, 2.6.38 shows the same problem.  I went back to ancient kernels
>> (2.6.31 on Fedora 11-alpha) which had the previous media_changed
>> infrastructure and those places too show the same behaviour (with the
>> TEST_UNIT_READY way of detecting media changes).
>
> Can you please the patch attached in the following bz and see whether
> it makes any difference?
>
>  https://bugzilla.kernel.org/show_bug.cgi?id=13029

Hi Tejun,
There is a related issue I have been discussing with Amit:
https://lkml.org/lkml/2011/3/23/156

On media change the inode size is not updated by the sr driver or the
universal cdrom driver.  A userspace process that holds a /dev/sr0
file descriptor open across media change causes all processes on the
system to see the old medium size when they do lseek(fd, 0, SEEK_END).

I think it would make sense to refresh the inode size on media change
so that even open file descriptors see the new size and a single
process cannot force a stale value for all other userspace processes
on the system.

Thoughts?

Stefan
