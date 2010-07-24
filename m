Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0GXQH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 12:07:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33623 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0GXQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 12:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LiWJSq9FzCgkFnSjC6JlOmmD/+kuFIKYdIKo+lYsAR8sLzRQ3eVfkel1METtjzV8+p
         qy3vqvyIQaJ6qbe2HTrQOGi9kKmdmKZ5fgqxl/b4RXHix7zzuDIqwaySevjzR/Go2Bch
         AKzMFeBJCyw/gaKRRwEeraDNYkQO3Ow+wnr28=
Date: Sat, 24 Jul 2010 20:07:01 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: check capabilities in open()
Message-ID: <20100724160701.GA4907@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found that some drivers check process capabilities via capable() in
open(), not in ioctl()/write()/etc.

I cannot find answer in POSIX, but IMO process expects that file
descriptors of priviledged user and file descriptors of the same
file/device are the same in priviledge aspect. Driver should deny/allow
open() and deny/allow ioctl() based on user priviledges. The path how
the process gained this fd doesn't matter.

So I think these 2 examples should be equal:

1) root process opened the file and then dropped its priviledges

2) nonroot process opened the file

Currently gained fds are different in priviledge aspect.


If you think these are bugs, I can move capable() checking down to
ioctl()/write()/read()/etc.



This is the full list of such drivers:

drivers/staging/comedi/comedi_fops.c
drivers/oprofile/event_buffer.c
drivers/s390/char/vmcp.c
drivers/s390/char/zcore.c
drivers/net/ppp_generic.c
drivers/scsi/3w-sas.c
drivers/scsi/pmcraid.c
drivers/scsi/megaraid.c
drivers/scsi/megaraid/megaraid_sas.c
drivers/scsi/megaraid/megaraid_mm.c
drivers/char/mem.c
drivers/char/tty_io.c
drivers/char/agp/frontend.c
drivers/char/apm-emulation.c


This is coccinelle script to find that:

@ r1 @
identifier fops;
identifier openx;
@@

struct file_operations fops = {
...
.open       = openx,
...
};


@@
identifier r1.openx;
@@

openx(...)
{
...
*capable(...)
...
}
