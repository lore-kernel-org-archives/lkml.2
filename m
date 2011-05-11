Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1EKWfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:35:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53394 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1EKWfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:35:05 -0400
MIME-Version: 1.0
Date: Wed, 11 May 2011 18:35:05 -0400
Message-ID: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
Subject: [PATCH] scsi/sd: fix suspend with USB-connected Android phone (one line)
From: Charles Hannum <root@ihack.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=485b397b93f122dc0d04a307af2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--485b397b93f122dc0d04a307af2a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Short version: My laptop doesn't suspend when my Android phone is
connected and has been =93ejected=94.

Long version:

Android phones connect as USB mass storage devices. =A0After the =93Turn
on USB storage=94 button has been clicked, there are a few different
ways to detach the =93disk=94:

1) pull the cable
2) click =93Turn off USB storage=94
3) =93eject=94 the device

In cases 2 & 3, the USB device is still attached to the system, but
will now return MEDIUM NOT PRESENT for many commands, including
SYNCHRONIZE CACHE=97basically it acts like any device with removable
media. =A0However, the act of the =93media=94 being removed does not
invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() still
call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
PRESENT sense code. =A0In the sd_suspend() case, this causes the entire
suspend to fail, and the laptop rewakes immediately.

There are a few different ways to fix this; e.g. one could
specifically test media_not_present() if a sense code is returned in
sd_sync_cache(). =A0However, the following patch seems simpler, and
avoids calling sd_sync_cache() at all in this case. =A0sdkp->WCE will be
reset when new medium is recognized and sd_read_cache_type() is
called. =A0Note this code always gets called=97it's in the same path as
sd_read_capacity(), which has to be called for the device to be usable
again; thus the patch is inherently safe.

Kernel tested: 2.6.38 (Ubuntu Natty)

--485b397b93f122dc0d04a307af2a
Content-Type: text/x-patch; charset=US-ASCII; name="sd-suspend.diff"
Content-Disposition: attachment; filename="sd-suspend.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnkukf650

LS0tIGxpbnV4LTIuNi4zOC9kcml2ZXJzL3Njc2kvc2QuYy5vcmlnCTIwMTEtMDUtMTEgMTg6MDg6
NDQuOTY5NDk3OTc2IC0wNDAwCisrKyBsaW51eC0yLjYuMzgvZHJpdmVycy9zY3NpL3NkLmMJMjAx
MS0wNS0xMSAxNToyNjoxNS40Mzk2MTA3NjAgLTA0MDAKQEAgLTk5Niw2ICs5OTYsNyBAQAogCWlm
IChzZGtwLT5kZXZpY2UtPnJlbW92YWJsZSkgewogCQlzZGtwLT5tZWRpYV9wcmVzZW50ID0gMDsK
IAkJc2RrcC0+Y2FwYWNpdHkgPSAwOworCQlzZGtwLT5XQ0UgPSAwOwogCX0KIH0KIAo=
--485b397b93f122dc0d04a307af2a--
