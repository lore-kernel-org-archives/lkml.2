Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0KRAB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:01:26 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9854 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0KRABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:01:24 -0500
Message-ID: <4CE46CCF.4080707@caviumnetworks.com>
Date: Wed, 17 Nov 2010 16:01:19 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] of/phylib: Use device tree properties to initialize
 Marvell PHYs.
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com> <1290038071-13296-2-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1290038071-13296-2-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 00:02:13.0954 (UTC) FILETIME=[DADF8220:01CB86B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 03:54 PM, David Daney wrote:
> Some aspects of PHY initialization are board dependent, things like
> indicator LED connections and some clocking modes cannot be determined
> by probing.  The dev_flags element of struct phy_device can be used to
> control these things if an appropriate value can be passed from the
> Ethernet driver.  We run into problems however if the PHY connections
> are specified by the device tree.  There is no way for the Ethernet
> driver to know what flags it should pass.
>
> If we are using the device tree, the struct phy_device will be
> populated with the device tree node corresponding to the PHY, and we
> can extract extra configuration information from there.
>
> The next question is what should the format of that information be?
> It is highly device specific, and the device tree representation
> should not be tied to any arbitrary kernel defined constants.  A
> straight forward representation is just to specify the exact bits that
> should be set using the "marvell,reg-init" property:
>
>        phy5: ethernet-phy@5 {
> 	reg =<5>;
> 	device_type = "ethernet-phy";
> 	marvell,reg-init =
> 		<0x00030010 0x5777>, /* Reg 3,16<- 0x5777 */
> 		<0x00030011 0x00aa>, /* Reg 3,17<- 0x00aa */
> 		<0x00030012 0x4105>, /* Reg 3,18<- 0x4105 */
> 		<0x00030013 0x0060>; /* Reg 3,19<- 0x0060 */
> 		<0x00020015 0x00300000>; /* clear bits 4..5 of Reg 2,21 */

Well, of course these mask bits are reversed.  That last line should 
really be:

  	<0x00020015 0xffcf0000>; /* clear bits 4..5 of Reg 2,21 */


>        };
>
> The Marvell PHYs have a page select register at register 22 (0x16), we
> can specify any register by its page and register number.  These are
> encoded in the high and low parts of the first word.  The second word
> contains a mask and value to be ORed in its high and low parts.
> property, the PHY initialization is unchanged.
[...]

David Daney
