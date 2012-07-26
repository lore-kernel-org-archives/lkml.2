Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2GZJld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:41:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49416 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2GZJlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:41:32 -0400
Message-ID: <1343295687.3115.27.camel@dabdike>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Thu, 26 Jul 2012 13:41:27 +0400
In-Reply-To: <50110D8C.8060802@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
	   <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
	  <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com>
	 <1343294472.3115.22.camel@dabdike> <50110D8C.8060802@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 11:27 +0200, Paolo Bonzini wrote:
> Il 26/07/2012 11:21, James Bottomley ha scritto:
> >> > Because scsilun_to_int does not do the AND, so it would have exactly the
> >> > same bug I'm fixing.
> > It's not a bug ... it's the encoding.  All the other devices use this
> > too.  Ideally we should have switched to 64 bit lun numbers for the
> > encoding to be exact, but nothing so far has gone over 32 bits.  If we
> > don't encode the Address method as part of the lun number, we don't get
> > the reverse transform right and the addressing often fails.
> 
> But virtio-scsi gets it right even if you use method=0 and method=1
> interchangeably.

I don't actually understand this statement.  LUNS < 256 may be encoded
either way (they should be encoded with address method=0 but they don't
have to be) if you address the array with the wrong method, it doesn't
have to give you your lun.  Therefore we have to map back to whatever
the array gave us.  Hence the 1:1 mapping.  You're proposing an
injective mapping, so you can't reliably reverse it; that's why we don't
do it that way in SCSI.

> ibmvscsi (see function lun_from_dev) does something similar to
> virtio-scsi, except here I need both directions.
> 
> > That does mean that arrays that use address method=1 in REPORT LUNS have
> > their lun numbers start at 16384.
> 
> That is ugly.  I can see how it may be needed on buggy hardware, but
> here we know it's not.

It's nothing to do with buggy hardware ... it's to do with having an
exact representation of the lun.

James


