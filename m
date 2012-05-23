Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2EWX2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:28:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53901 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2EWX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:28:43 -0400
Message-ID: <4FBD72A7.907@wwwdotorg.org>
Date: Wed, 23 May 2012 17:28:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] regmap: allow busses to request formatting with specific
 endianness
References: <1337812434-7609-1-git-send-email-swarren@wwwdotorg.org> <20120523231641.GA5361@opensource.wolfsonmicro.com>
In-Reply-To: <20120523231641.GA5361@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 05:16 PM, Mark Brown wrote:
> On Wed, May 23, 2012 at 04:33:53PM -0600, Stephen Warren wrote:
> 
>> I'm not 100% sure if this is the approach you had in mind.
>> However, anything more all-encompassing would require separating
>> the concepts of endianness and
> 
> I wouldn't do this on the bus in the first instance, I'd do it on
> the device - it's pretty much orthogonal to the bus what the device
> wants and it's perfectly plausible that a device on another bus
> might've made unusual endiannness choices.  Otherwise it's pretty
> much what I was thinking of.
> 
> For MMIO I'd expect that a large proportion of devices on platform
> buses would pick native endianness.

I did briefly consider making this a property of regmap_config rather
than regmap_bus, but as you say, it'd mean every MMIO user would have
to specify the endianness value.

Also, it doesn't seem right for a device to be able to specify
register formatting endianness for MMIO; presumably we'd always want
that native.

Perhaps the solution is to have two fields; one for address formatting
(the endianness of which regmap-mmio.c will error-check is "native",
like it error-checks other fields) and a second for value
formatting/parsing, which I can see a device might want to influence
(e.g. to fix a byte swap in HW).

I suppose we could avoid every device having to specify the endianness
by introducing a fourth "DEFAULT" value == 0, and having the bus
define what default means - that way, I wouldn't have to edit any
drivers due to adding the regmap_bus field.

>> serialization that are coupled together in functions like 
>> regmap_format_4_12_write, and I'm not sure how that would work
>> conceptually.
> 
> Anything using format_write() can be ignored, it's already lost
> large chunks of functionality just from that.  Non-integer byte
> sizes cause issues.

