Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0G2WVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:21:21 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:25691 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754807Ab0G2WVU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:21:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 433705.78454.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gpCCnp0dXuo0V6v5pxQ3XGtGwOveQ5fwrWxdTXKLw/6jkgv4zRcxTxF8/9sr93TCgU/dVT1JNYj11hJaKObsKMN81KH9G5F4J1HQ4y3gsBvusVN+/VbYYq0xiZHN0HtDA11JI5IbLSdA6jn+PB7dOUa1YkhdAJmhrCgdIHwbG+c=;
Message-ID: <231296.268.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: XBBL8lIVM1kH083kFwuqGIkLbRlKdKL2xPSUYIehD0YStI5
 4KMqHKowSDgHNgB4Iwdy2g3XF2Mn7CCwpklkIHtW0MIzoKY23_sE3ZJXG3oY
 K8QKFnSn_azM.gAGr.LUEWQPRHkF95Nh2MMpVBzJnNTVlIuybwrqV9jJFE9s
 t7l80lYk679Itw1bBbV3jbyYgc1upjEAtka5y5MHmd87CZ2gvlPkSDrRu7yC
 LWNL2N0Tovx_NxML2YGc5WB2sbb4WRSKikNvh8yehtAq9JlcKsmng9Gqe9rx
 Twbgh7BUpbCR1FYXBDTHTEeuL1sWcJJaBPRKuF51.G72pryizieDMjTEQAnT
 jW4i4HyAPvI.7Obs-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.105.277674
Date: Thu, 29 Jul 2010 15:21:18 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets
To: Greg KH <greg@kroah.com>, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 7/28/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:

> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Subject: [PATCHv5 2/3] USB: gadget: Use new composite features in some gadgets

NAK


Let's have one patch per gadget or function driver.
WITH a good explanation of what's changed in each.

What I see is a whole lot of random changes that
don't make ANY sense as one combined patch.  Plus,
some look quite dubious...


> use the new features of composite framework.  Because
> it
> handles default strings there is no longer the need for
> the
> gadgets drivers to handle many of the strings.

The gadgets should always identify the same, and
thus handle their strings -- *unless* module params
are applied by users to override those defaults.
The reason to use the module params is because a
product wants to be a *different* gadget, which
must be possible but won't be routine.  It
suffices to be different instances (serial #s)
in most routine usage.

> 
> This also adds the "needs_serial" to Mass Storage
> Gadget and

When the mass-storage only patch gets sent, I'll
want to see Alan's ack.

> Multifunction Composite Gadget which makes composite issue
> a warning if user space has not provided iSerialNumber parameter.
> 
>  
>  
> -static unsigned short gfs_vendor_id    =
> 0x0525;    /* XXX NetChip */
> -static unsigned short gfs_product_id   =
> 0xa4ac;    /* XXX */

Look -- you can't assign NetChip numbers!!!  I
personally have a handful of them, and if I didn't
assign them, they CANNOT be used.  That XXX
makes me think you (or someone) just randomly
picked a (broken) number.  The original file
storage gadget had a correctly assigned number.
If you're using anything else, fix it; there are
numbers Greg can assign from Linux Foundation's
USB-IF membership.

Comments like "XXX" need explanations, too...
if the intent is to seem like the file storage
gadget, just say so.


>  
> -    /* Vendor and product id can be
> overridden by module parameters.  */
> -    /* .idVendor   
>     = cpu_to_le16(gfs_vendor_id), */
> -    /* .idProduct   
>     = cpu_to_le16(gfs_product_id), */


Again, screwey.  Use the standard IDs unless
they get overridden.  Don't require them to be
overridden ... they were assigned in the first
place to be safe.  Module overrides are for folk
who put out their own products and want them to be
visibly different from  the generic Linux ones,
and thus need to manage their own USB-IF vid/pid
codes

What you're doing is changing the whole model so
there's no longer a standard "this is what Linux
does by default" -- and *requiring* a lot more
pain and suffering from folk configuring gadgets.
PLUS ... almost ensuring they'll get it wrong.  Not
anything vaguely like an improvement.


> -    /* .bcdDevice   
>     = f(hardware) */
> -    /* .iManufacturer    =
> DYNAMIC */
> -    /* .iProduct   
>     = DYNAMIC */
> -    /* NO SERIAL NUMBER */
> -    .bNumConfigurations    =
> 1,
> +    .idVendor   
>     = cpu_to_le16(0x0525),
> +    .idProduct   
>     = cpu_to_le16(0xa4ac),

Same as above.  You've broken ID management.
Use the (correct) symbols, not magic numbers.

Do you not understand how fundamental proper
management of vendor and product IDs is????












