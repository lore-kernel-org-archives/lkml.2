Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918Ab2KNWUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:20:33 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49674 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab2KNWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:20:32 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 3.7.0-rc2] dt: match id-table before creating platform device
To: srinivas.kandagatla@st.com, Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <508A37E6.8000401@st.com>
References: <1350988259-22767-1-git-send-email-srinivas.kandagatla@st.com> <5086988F.6090107@gmail.com> <508A37E6.8000401@st.com>
Date: Wed, 14 Nov 2012 22:20:28 +0000
Message-Id: <20121114222029.0DA643E0E2B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012 08:12:38 +0100, Srinivas KANDAGATLA <srinivas.kandagatla@st.com> wrote:
> On 23/10/12 14:15, Rob Herring wrote:
> re-sending my reply again, as it did not appear in my inbox from dt
> mailing list.
> > Adding lkml. DT patches should go to both lists.
> >
> > On 10/23/2012 05:30 AM, Srinivas KANDAGATLA wrote:
> >> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >>
> >> As part of of_platform_populate call, the existing code iterates each
> >> child node and then creates a platform device for each child, however
> >> there is bug in the code which does not check the match table before
> >> creating the platform device. This might result creating two platfrom
> >> devices and also invoking driver probe twice, which is incorrect.
> >>
> >> This patch moves a existing of_match_node check to start of the function
> >> to fix the bug, doing this way will return immediately without creating
> >> any datastructures if the child does not match the supplied match-table.
> >>
> >> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >> ---
> >>  drivers/of/platform.c |    5 ++++-
> >>  1 files changed, 4 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> >> index b80891b..1aaa560 100644
> >> --- a/drivers/of/platform.c
> >> +++ b/drivers/of/platform.c
> >> @@ -367,6 +367,9 @@ static int of_platform_bus_create(struct device_node *bus,
> >>  		return 0;
> >>  	}
> >>  
> >> +	if (!of_match_node(matches, bus))
> >> +		return 0;
> >> +
> > This is not right. This function is recursive and this change would
> > break that.
> 
> You are correct, this change might break the functionality.
> 
> 
> >  Perhaps we could only call of_platform_device_create_pdata
> > if !of_match_node instead, but I'm not completely sure that would be the
> > right thing to do.
> 
> I did try to do the same thing in the patch.
> May be I should have moved check just before calling
> of_platform_device_create_pdata?

No, the current code is correct. The purpose of the match table passed
to of_platform_populate is to figure out which nodes are bus nodes that
need to be recursed into.

However, *every single* child node of the root when
of_platform_populate() is called will be used to create a
platform_device. This is by design.

So, if somewhere is calling of_platform_populate() with the expectation
that it will only create devices for a subset of the nodes, then that
code is working on an incorrect assumption.

> 
> >  There's also some historical things we have to
> > support which is why we have of_platform_populate and of_platform_bus_probe.
> 
> m just trying to understand the difference between of_platform_populate
> and of_platform_bus_probe.
> Looking at the function documentation, which states
> of_platform_bus_probe will only create children of the root which are
> selected by the @matches argument.
> 
> of_platform_populate walks the device tree and creates devices from
> nodes.  It differs in that it follows the modern convention of requiring
> all device nodes to have a 'compatible' property, and it is suitable for
> creating devices which are children of the root node.
> 
> Lets say If we call of_platform_populate(NULL, match_table, NULL, NULL)
> on a device trees like the below with
> struct of_device_id match_table[] = {
>     { .compatible = "simple-bus", }
>     {}
> };
> 
> parent@0{
>     compatible    = "xxx,parent1", "simple-bus";
>     ...
>     child@0 {
>         compatible    = "xxx,child0", "simple-bus";
>         ...
>     };
>     child@1 {
>         compatible    = "xxx,child1";
>         ...
>     };
>     child@2 {
>         compatible    = "xxx,child2", "simple-bus";
>         ...
>     };
> };
> 
> of_platform_bus_probe would create platform-devices for parent@0,
> child@0and child@2
> where as
> of_platform_populate would create platform-devices for parent@0,
> child@0, child@1 and child@2 nodes.
> 
> So the question is
> why do we need to have @matches argument to of_platform_populate in the
> first place, if it creates all the devices by walking the dt nodes?

of_platform_populate will create devices for all the children of
child@0 and child@2 also. The intent is for generic board support to
call of_platform_populate() on the root of the tree and have all the
nodes with compatible properties *and all the children of simple memory
mapped busses* created into devices. This is normally what we want;
particularly for new board support.

> 
> It is bit confusing, As some platforms use of_platform_populate(NULL,
> of_default_bus_match_table, NULL, NULL) assuming that only matching
> nodes will end up having platform device.
> Also
> some platforms use of_platform_bus_probe(NULL, match_table, NULL), 
> where match table is of_default_bus_match_table.

of_platform_bus_probe() is old code used by most of the powerpc
platforms. Don't use it for new board support.

g.
