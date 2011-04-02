Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1DBT3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:29:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52468 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1DBT3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BCKFpqmXe8vIZkHkd+7WpoJEbOwCDiRGb/bk2RyVfvrGstZhxxqcVwHof3oQA5M2rz
         KA+srhZ8+vyftXGcalwVy7/Hq84go0KloniN1lCxSknP+5KdfKdUbuijYjoGe1OzwgEg
         Wu3Wg88NDwQ+nUSe8EVwEXe43cIyAP+etPces=
Date: Sat, 2 Apr 2011 14:29:02 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andreas Huber <a.huber@corax.at>
Cc: linux-media@vger.kernel.org, Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>, Roland Stoll <dvb.rs@xindex.de>
Subject: Re: [PATCH 3/3] [media] cx88: use a mutex to protect cx8802_devlist
Message-ID: <20110402192902.GD20064@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110402094451.GD17015@elie>
 <4D971B8D.4040305@corax.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D971B8D.4040305@corax.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

(please turn off HTML mail.)
Andreas Huber wrote:

> There is a reference count bug in the driver code. The driver's
> active_ref count may become negative which leads to unpredictable
> behavior. (mpeg video device inaccessible, etc ...)

Hmm, the patchset didn't touch active_ref handling.

active_ref was added by v2.6.25-rc3~132^2~7 (V4L/DVB (7194):
cx88-mpeg: Allow concurrent access to cx88-mpeg devices, 2008-02-11)
and relies on three assumptions:

 * (successful) calls to cx8802_driver::request_acquire are balanced
   with calls to cx8802_driver::request_release;

 * cx8802_driver::advise_acquire is non-null if and only if
   cx8802_driver::advise_release is (since both are NULL for
   blackbird, non-NULL for dvb);

 * no data races.

I suppose it would be more idiomatic to use an atomic_t, but access to
active_ref was previously protected by the BKL and now it is protected
by core->lock.  So it's not clear to me why this doesn't work.

Any hints?  (e.g., a detailed reproduction recipe, or a log after
adding a printk to find out when exactly active_ref becomes negative)

Thanks for reporting.
Jonathan
