Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2DXQkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab2DXQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:40:07 -0400
Message-ID: <4F96D75C.1080900@redhat.com>
Date: Tue, 24 Apr 2012 13:39:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory location
References: <4F969FC4.9080307@redhat.com> <1335271799-6263-1-git-send-email-mchehab@redhat.com> <20120424130925.GD11559@aftab.osrc.amd.com> <4F96A901.6070100@redhat.com> <20120424133855.GJ11559@aftab.osrc.amd.com>
In-Reply-To: <20120424133855.GJ11559@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-04-2012 10:38, Borislav Petkov escreveu:
> On Tue, Apr 24, 2012 at 10:22:09AM -0300, Mauro Carvalho Chehab wrote:
>> The count of elements of a layer is the size of the layer. The Kernel macro
>> that gets the number of elements of an array is called "ARRAY_SIZE", and not
>> "ARRAY_N_ELEMS".
>>
>> layers->size is the dimension of the layer. So, the term "size" fits better.
>> For example, according with [1], size means:
>> 	"the spatial dimensions, proportions, magnitude, or bulk of anything:
>> 	 the size of a farm; the size of the fish you caught."
>>
>> so, "size" fits better for a "dimension" measure.
>>
>> I don't mind renaming it to n_elems, if this makes you happy.
> 
> Ok, let's do a simple comparison:
> 
> 1. Imagine you look at ARRAY_SIZE(), what does it mean? Well, the size
> of an array is pretty well defined to be the number of elements in it.
> Easy.
> 
> 2. Now imagine a struct member ->size. Out of context it could mean
> anything, the size of something this struct represents, what the hell do
> I know...

The size of a memory architecture layer is the number of physical components 
on it:

So, for example (from i7300_edac, just to get an example with 3 layers):

...
#define MAX_SLOTS		8
#define MAX_BRANCHES		2
#define MAX_CH_PER_BRANCH	2
...
	layers[0].type = EDAC_MC_LAYER_BRANCH;
	layers[0].size = MAX_BRANCHES;
	layers[0].is_csrow = false;
	layers[1].type = EDAC_MC_LAYER_CHANNEL;
	layers[1].size = MAX_CH_PER_BRANCH;
	layers[1].is_csrow = true;
	layers[2].type = EDAC_MC_LAYER_SLOT;
	layers[2].size = MAX_SLOTS;
	layers[2].is_csrow = true;

This means that there are 2 branches at the branch layer, 2 channels
per branch, at the channel layer, and 8 DIMM slots, at the slot layer.

The maximum number of DIMMs on this MCU is 32 DIMMs.

Calling "2 channels" as n_elems = 2 doesn't sound nice.

> 
> Now let's put it in context, layer->size: It could mean the size of the
> layer in MB, it could mean how thick the layer is in meters, it could
> ... I can go on with these forever.
> 
> So your example with ARRAY_SIZE does not apply here.
> 
> If it is a badly explained struct and size is "maximum size" then this
> means sh*t. So either leave it "size" but make sure to explain it
> thoroughly what exactly size means here or change its name to something
> more meaningful.

Ok, I'll apply then the explanation below:

diff --git a/include/linux/edac.h b/include/linux/edac.h
index 671b27b..934c196 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -348,7 +348,8 @@ enum edac_mc_layer_type {
 /**
  * struct edac_mc_layer - describes the memory controller hierarchy
  * @layer:		layer type
- * @size:maximum size of the layer
+ * @size:		number of components on that layer. For example,
+ *			if the channel layer have two channels, size = 2
  * @is_virt_csrow:	This layer is part of the "csrow" when old API
  *			compatibility mode is enabled. Otherwise, it is
  *			a channel
