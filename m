Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2FKP4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:56:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47261 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2FKP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:56:19 -0400
Message-ID: <4FD6151E.8010405@wwwdotorg.org>
Date: Mon, 11 Jun 2012 09:56:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com> <4FBBDA97.6000006@wwwdotorg.org> <4FBBDE06.5080806@nvidia.com> <4FC916AC.4060804@wwwdotorg.org> <4FD250DB.2090207@nvidia.com> <20120609030608.GF3924@opensource.wolfsonmicro.com> <4FD2CFE6.9070500@wwwdotorg.org> <20120611025717.GE28211@opensource.wolfsonmicro.com>
In-Reply-To: <20120611025717.GE28211@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 08:57 PM, Mark Brown wrote:
> On Fri, Jun 08, 2012 at 10:24:06PM -0600, Stephen Warren wrote:
>> On 06/08/2012 09:06 PM, Mark Brown wrote:
> 
>>> If we're going to do this we need to update all the existing DT bindings
>>> for drivers that use single node regulators like this.  Please also
>>> change the name used for the property to regulator-compatible to make it
>>> clear that the idea is the same as normal compatible properties.
> 
>> I'm not sure of the logic behind naming the property
>> "regulator-compatible"; the standard compatible property identifies that
>> the node is of a particular type/class, whereas the regulator-id in the
>> example Laxman quoted would indicate the specific identity/object. Those
>> seem like different things.
> 
> They're both doing the same thing - up until you get the second register
> compatible device a compatible binding is referencing a specific thing
> too.  It's just saying "handle this like an X".

I believe there's a big semantic difference here.

For every node with compatible="foo", you find a driver for "foo" and
instantiate it. This will work for any number of nodes with that
compatible value. The nodes are completely independent and there are no
particular requirements re: what the parent of those nodes are, beyond
being a bus of an appropriate type such as any old I2C bus.

However, with the regulator identifiers, it's almost exactly the opposite:

* There's no generic "search all busses in the system for this regulator
type", but rather once a particular type of regulator chip gets
instantiated, that chip's HW design defines which specific regulators it
contains, and nodes for those regulators may exist as children of the
regulator chip itself, and nowhere else. The individual driver is then
going to look for child nodes with specific
regulator-id/regulator-compatible values, not some arbitrary centralized
table of possible values.

* Each regulator-id/regulator-compatible value identifies a specific
individual regulator within the chip that contains it. There is only one
of each named regulator, since that's what exists in HW. So, this is
about configuring HW that we know exists (because it's part of the HW
represented by the parent node for the chip) rather than defining which
HW is present on unprobeable busses, as the device-level compatible does.

Given those differences, I really think that using "compatible" in the
name of the property is just going to cause confusion.
