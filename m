Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1AEWxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:53:36 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:45593 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1AEWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:53:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Organization: Mentor Graphics, Embedded Systems Division
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.7
Content-class: urn:content-classes:message
Subject: Re: [PATCH] of/device: Don't register disabled devices
Date: Wed, 5 Jan 2011 14:53:27 -0800
Message-ID: <DD7A9A95166BF4418C4C1EB2033B6EE2038FA8E5@na3-mail.mgc.mentorg.com>
In-Reply-To: <20110103230122.25772.72990.stgit@localhost6.localdomain6>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] of/device: Don't register disabled devices
Thread-Index: AcutK14nb60BK/n7T5WdHHmLzJkm2A==
References: <20110103230122.25772.72990.stgit@localhost6.localdomain6>
From: "Blanchard, Hollis" <Hollis_Blanchard@mentor.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: <devicetree-discuss@lists.ozlabs.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, "Scott Wood" <scottwood@freescale.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        "Saxena, Deepak" <deepak_saxena@mentor.com>
X-OriginalArrivalTime: 05 Jan 2011 22:53:28.0189 (UTC) FILETIME=[5DF77AD0:01CBAD2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p05MrirK019811

On 01/03/2011 03:01 PM, Grant Likely wrote:
> Device nodes with the property status="disabled" are not usable and so
> don't register them when parsing the device tree for devices.
>
This is great and all, but a fair amount of driver code explicitly 
searches the tree, rather than registering a probe function. That's why 
our earlier patches in this area were more comprehensive.

What are your thoughts on handling those cases?

Hollis Blanchard
Mentor Graphics, Embedded Systems Division

> ---
>   drivers/of/platform.c |   22 ++++++++++++++--------
>   1 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 5b4a07f..c01cd1a 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -633,6 +633,9 @@ EXPORT_SYMBOL(of_device_alloc);
>    * @np: pointer to node to create device for
>    * @bus_id: name to assign device
>    * @parent: Linux device model parent device.
> + *
> + * Returns pointer to created platform device, or NULL if a device was not
> + * registered.  Unavailable devices will not get registered.
>    */
>   struct platform_device *of_platform_device_create(struct device_node *np,
>   					    const char *bus_id,
> @@ -640,6 +643,9 @@ struct platform_device *of_platform_device_create(struct device_node *np,
>   {
>   	struct platform_device *dev;
>
> +	if (!of_device_is_available(np))
> +		return NULL;
> +
>   	dev = of_device_alloc(np, bus_id, parent);
>   	if (!dev)
>   		return NULL;
> @@ -683,8 +689,9 @@ static int of_platform_bus_create(const struct device_node *bus,
>   		pr_debug("   create child: %s\n", child->full_name);
>   		dev = of_platform_device_create(child, NULL, parent);
>   		if (dev == NULL)
> -			rc = -ENOMEM;
> -		else if (!of_match_node(matches, child))
> +			continue;
> +
> +		if (!of_match_node(matches, child))
>   			continue;
>   		if (rc == 0) {
>   			pr_debug("   and sub busses\n");
> @@ -733,10 +740,9 @@ int of_platform_bus_probe(struct device_node *root,
>   	if (of_match_node(matches, root)) {
>   		pr_debug(" root match, create all sub devices\n");
>   		dev = of_platform_device_create(root, NULL, parent);
> -		if (dev == NULL) {
> -			rc = -ENOMEM;
> +		if (dev == NULL)
>   			goto bail;
> -		}
> +
>   		pr_debug(" create all sub busses\n");
>   		rc = of_platform_bus_create(root, matches,&dev->dev);
>   		goto bail;
> @@ -748,9 +754,9 @@ int of_platform_bus_probe(struct device_node *root,
>   		pr_debug("  match: %s\n", child->full_name);
>   		dev = of_platform_device_create(child, NULL, parent);
>   		if (dev == NULL)
> -			rc = -ENOMEM;
> -		else
> -			rc = of_platform_bus_create(child, matches,&dev->dev);
> +			continue;
> +
> +		rc = of_platform_bus_create(child, matches,&dev->dev);
>   		if (rc) {
>   			of_node_put(child);
>   			break;
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
