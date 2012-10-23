Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2JWNQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:16:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42371 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab2JWNQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:16:04 -0400
Message-ID: <5086988F.6090107@gmail.com>
Date: Tue, 23 Oct 2012 08:15:59 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3.7.0-rc2] dt: match id-table before creating platform
 device
References: <1350988259-22767-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1350988259-22767-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding lkml. DT patches should go to both lists.

On 10/23/2012 05:30 AM, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> As part of of_platform_populate call, the existing code iterates each
> child node and then creates a platform device for each child, however
> there is bug in the code which does not check the match table before
> creating the platform device. This might result creating two platfrom
> devices and also invoking driver probe twice, which is incorrect.
> 
> This patch moves a existing of_match_node check to start of the function
> to fix the bug, doing this way will return immediately without creating
> any datastructures if the child does not match the supplied match-table.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  drivers/of/platform.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b80891b..1aaa560 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -367,6 +367,9 @@ static int of_platform_bus_create(struct device_node *bus,
>  		return 0;
>  	}
>  
> +	if (!of_match_node(matches, bus))
> +		return 0;
> +

This is not right. This function is recursive and this change would
break that. Perhaps we could only call of_platform_device_create_pdata
if !of_match_node instead, but I'm not completely sure that would be the
right thing to do. There's also some historical things we have to
support which is why we have of_platform_populate and of_platform_bus_probe.

Rob

>  	auxdata = of_dev_lookup(lookup, bus);
>  	if (auxdata) {
>  		bus_id = auxdata->name;
> @@ -379,7 +382,7 @@ static int of_platform_bus_create(struct device_node *bus,
>  	}
>  
>  	dev = of_platform_device_create_pdata(bus, bus_id, platform_data, parent);
> -	if (!dev || !of_match_node(matches, bus))
> +	if (!dev)
>  		return 0;
>  
>  	for_each_child_of_node(bus, child) {
> 

