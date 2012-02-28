Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2B1QmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:42:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2B1QmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:42:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL replacement
Date: Tue, 28 Feb 2012 16:42:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120228153244.70413d34@stein> <20120228170930.132f7c1e@stein> <1330445795.2822.134.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330445795.2822.134.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202281642.16496.arnd@arndb.de>
X-Provags-ID: V02:K0:R7WjhE1VFlh09YitYWnjOg/xgM5L4BTR6hYrOgkgZii
 /UF+aOKm1r+axF4/O/gbVUU33OpKJSAEj2wny0qMjeVDamCW2o
 SXUITT8Zt6RkniPJb7lTIZhx+zEzEboV84ajTKF4hNFF6VCgw7
 mXz80qCM0xixTQSfcFJT6B3XIF6DWHAt+MgltWMIUn13AXFIao
 r7EFblYAGYTfKlcqwPKUkEAlkhElKMoMmJIapUUPp9HoE0DyqJ
 z1m0ndv0lI36gbfCKly/gsGEJmkNGKW7Jrh+Nak+kmbsaSt5+K
 MG6E645FJodw1EexAJ//ba2VE6MI6Ny29thhjLUFqmlKCqkSpF
 KweSTgvogHz17842/GWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 February 2012, James Bottomley wrote:
> On Tue, 2012-02-28 at 17:09 +0100, Stefan Richter wrote:
> > On Feb 28 James Bottomley wrote:
> > 
> > While I do remove sr_mutex aroud scsi_cd_get/put() calls, these ones
> > internally use another lock: sr_ref_mutex.  Always did, still do, since
> > neither Arnd's mechanical BKL pushdown and BKL-to-mutex conversions
> > patches nor my patch changed that.  This sr_ref_mutex also protects sr's
> > reference counting outside of the three block_device_operations methods
> > which I changed.
> > 
> > I suppose I could have mentioned right away in the changelog that the
> > sr driver's own reference counting serialization remains in place, via that
> > other mutex.
> 
> OK, agreed ... the thing that caught my eye was the get/open and the
> release/put, but I think that's completely safe.

I took another look and I believe the cdi->use_count in
cdrom_open/cdrom_release still requires some protection that is
currently provided by sr_mutex. Some parts of cdrom_ioctl also
access this variable and things like cdi->options or cdi->keeplocked.

I could imagine that you can get rid of the mutex if you turn those
into atomics and bitops, but there may be other parts of cdrom_device_info
that need locking. A safer option to solve the performance problems
could be to replace sr_mutex with a per-device mutex inside of
cdrom_device_info.

	Arnd
