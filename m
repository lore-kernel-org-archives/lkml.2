Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1ATIL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:11:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54015 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1ATIL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=exoWOT56HDlNw7/JA05b7jjRls/A+OB6xZOcv3hYXiLFb/f4KgyoWHWzNXMJdzUWYN
         E/z7lsyukWVDyif0IIy2mGduL5jwlRderpiPlp9OHU5Qx2XxIXTMVgCqXbQ58W+kj4dn
         bGVxhydz/xP5xbmt3OaGQmfnNLuGHXNQWp/A4=
Date: Thu, 20 Jan 2011 00:11:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tapio Vihuri <tapio.vihuri@nokia.com>
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: Re: [PATCH v4 1/3] ECI: input: introduce ECI accessory input driver
Message-ID: <20110120081117.GB2498@core.coreip.homeip.net>
References: <1295438816-27937-1-git-send-email-tapio.vihuri@nokia.com>
 <1295438816-27937-2-git-send-email-tapio.vihuri@nokia.com>
 <20110119174412.GB29107@core.coreip.homeip.net>
 <1295510248.26257.7.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295510248.26257.7.camel@dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:57:28AM +0200, Tapio Vihuri wrote:
> On Wed, 2011-01-19 at 09:44 -0800, ext Dmitry Torokhov wrote:
> > Hi Tapio,
> > 
> > On Wed, Jan 19, 2011 at 02:06:54PM +0200, tapio.vihuri@nokia.com wrote:
> > > +
> > > +	for (; key->type != KE_END; key++) {
> > > +		switch (key->type) {
> > > +		case KE_KEY:
> > > +			__set_bit(key->keycode, eci->acc_input->keybit);
> > > +			break;
> > > +		case KE_SW:
> > > +		case KE_VSW:
> > > +			__set_bit(key->keycode, eci->acc_input->swbit);
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > 
> > Is this still needed? I believe sparse_keymap_setup() below shoudl take
> > care of this...
> > 
> > > +	__set_bit(EV_KEY, eci->acc_input->evbit);
> > > +	__set_bit(EV_SW, eci->acc_input->evbit);
> > > +	__set_bit(EV_REP, eci->acc_input->evbit);
> > > +
> > > +	err = sparse_keymap_setup(eci->acc_input, eci_keymap, NULL);
> > > +	if (err)
> > > +		goto err_free_dev;
> > > +
> > 
> 
> Hi Dmitry.
> 
> Thanks for pointing this out, as we have sparse keymap, we should use
> it :)
> 
> How about KE_VSW case ? Shouldn't it be in the sparse_keymap_setup {}
> also ?
> 

Indeed. Does the patch below fix it?

Thanks.

-- 
Dmitry

Input: sparse-keymap - fix KEY_VSW handling in sparse_keymap_setup

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

We were forgetting to set up device capabilities for KEY_VSW entries.

Reported-by: Tapio Vihuri <tapio.vihuri@nokia.com> 
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/sparse-keymap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index a29a7812..7729e54 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -201,6 +201,7 @@ int sparse_keymap_setup(struct input_dev *dev,
 			break;
 
 		case KE_SW:
+		case KE_VSW:
 			__set_bit(EV_SW, dev->evbit);
 			__set_bit(entry->sw.code, dev->swbit);
 			break;
