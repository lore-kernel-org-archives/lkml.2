Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab0KSXCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:02:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63929 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab0KSXCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OyKdUM9AnYw4CNf7zub6b26c+RC8T0p/fvsSWnuLZANlLrFsH49MemQ4mplcGif///
         tbPFAzYnfelJ0PEFwA+3tfQv0u0oGer16jsNkI8BWS9vqAoy/XNM2H7YtTopUh0XkYz3
         tbfnV2dClVAZtOTQw4MOnq9R4PNswY3hesARM=
MIME-Version: 1.0
In-Reply-To: <1290204798-28569-1-git-send-email-ddaney@caviumnetworks.com>
References: <1290204798-28569-1-git-send-email-ddaney@caviumnetworks.com>
Date: Fri, 19 Nov 2010 17:02:08 -0600
Message-ID: <AANLkTikuikWgLbW67m1Ov0dt13A=DTSF150aTOs=PybT@mail.gmail.com>
Subject: Re: [PATCH v2] of/phylib: Use device tree properties to initialize
 Marvell PHYs.
From: Andy Fleming <afleming@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 4:13 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> Some aspects of PHY initialization are board dependent, things like
> indicator LED connections and some clocking modes cannot be determined
> by probing.  The dev_flags element of struct phy_device can be used to
> control these things if an appropriate value can be passed from the
> Ethernet driver.  We run into problems however if the PHY connections
> are specified by the device tree.  There is no way for the Ethernet
> driver to know what flags it should pass.
>
> If we are using the device tree, the struct phy_device will be
> populated with the device tree node corresponding to the PHY, and we
> can extract extra configuration information from there.
>
> The next question is what should the format of that information be?
> It is highly device specific, and the device tree representation
> should not be tied to any arbitrary kernel defined constants.  A
> straight forward representation is just to specify the exact bits that
> should be set using the "marvell,reg-init" property:
>
>      phy5: ethernet-phy@5 {
>        reg = <5>;
>        compatible = "marvell,88e1149r";
>        marvell,reg-init =
>                /* led[0]:1000, led[1]:100, led[2]:10, led[3]:tx */
>                <3 0x10 0 0x5777>, /* Reg 3,16 <- 0x5777 */
>                /* mix %:0, led[0123]:drive low off hiZ */
>                <3 0x11 0 0x00aa>, /* Reg 3,17 <- 0x00aa */
>                /* default blink periods. */
>                <3 0x12 0 0x4105>, /* Reg 3,18 <- 0x4105 */
>                /* led[4]:rx, led[5]:dplx, led[45]:drive low off hiZ */
>                <3 0x13 0 0x0a60>; /* Reg 3,19 <- 0x0a60 */


My inclination is to shy away from such hard-coded values.  I agreed
with Grant's comment about separating into separate cells, but I think
specification of hard-coded register writes is too rigid.  I think a
better approach would be to specify configuration attributes, like:

marvell,blink-periods = <blah>;
marvell,led-config = <[drive type] [indicates]>;

For one, I always advocate making the DTS human-readable.  For
another, I think that there are a number of configuration sequences
that require read-modify-write, or write-wait-write.  In other words,
I think that there are enough cases where actual software will be
needed, that an attempt to generically specify a register
initialization sequence will be impossible, and leave us with the same
problems to solve later on.  For third...ly... allowing
device-tree-specified register initializations might encourage
developers to put all of their register initializations in the device
tree.  Especially when they realize that the LED initialization for
*their* PHY has to come between two standard initialization steps in
the driver.  Or before.  Or after.

By specifying actual functionality, the driver can work around those
problems, while being aware of the functional goal.  However, I'm
aware that such a path is more difficult, and perhaps just as futile,
as PHY vendors frequently don't want to document what their magic
sequences mean.

Andy
