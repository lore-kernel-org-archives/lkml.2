Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab2C1GCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:02:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51079 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2C1GCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:02:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuYYwRxCTWxnof1HUqYVX4mbzWCxcab69CJyKxOh13bQbQ_5Q@mail.gmail.com>
References: <CAJuYYwS5Srw2-D6hdk=-=YN3iB37+KTWVqQPPPVbb-e7it+uVQ@mail.gmail.com>
	<1332679129-23864-1-git-send-email-thomas.abraham@linaro.org>
	<4F6F37B6.3050506@gmail.com>
	<CAJuYYwTzx8+J9oMRd7kJ=Qp5V4v0LVUYxdkAe8dMqVji0Dk4yg@mail.gmail.com>
	<4F706947.2080405@gmail.com>
	<CAJuYYwRxCTWxnof1HUqYVX4mbzWCxcab69CJyKxOh13bQbQ_5Q@mail.gmail.com>
Date: Wed, 28 Mar 2012 11:32:20 +0530
Message-ID: <CAJuYYwSTA_oibeF0maCeaMnw4z2hU33wBjW_ussfLY9S-=UEmA@mail.gmail.com>
Subject: Re: [PATCH] of/irq: of_irq_init: Call initialization function for all controllers
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, rob.herring@calxeda.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2012 21:06, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> On 26 March 2012 18:34, Rob Herring <robherring2@gmail.com> wrote:

>> Your fix doesn't really guarantee the proper order either. It's still a
>> side effect of the implementation. Perhaps a retry mechanism would work.
>> Then the init for wakeup_eint can retry if the gic is not yet setup.
>
> Ok. A retry mechanism would be most robust solution for this case.
>

Hi Rob,

I have attempted an implementation of the the retry mechanism in the
of_irq_init() function. It allows initialization functions of
interrupt controller nodes to report -EAGAIN indicating that the
initialization was not complete and should be retried.

I have tested this and it is working fine. But the complexity of the
interrupt controller's intialization function increases because it has
to undo some of the intialization steps it completed before finding
that the its parent controller was not initialized.

The following is the diff of the changes for of_irq_init() function.
Please let know if this is acceptable.

Thanks,
Thomas.

@@ -452,7 +454,6 @@ void __init of_irq_init(const struct of_device_id *matches)
 			if (desc->interrupt_parent != parent)
 				continue;

-			list_del(&desc->list);
 			match = of_match_node(matches, desc->dev);
 			if (WARN(!match->data,
 			    "of_irq_init: no init function for %s\n",
@@ -466,6 +467,14 @@ void __init of_irq_init(const struct of_device_id *matches)
 				 desc->dev, desc->interrupt_parent);
 			irq_init_cb = match->data;
 			ret = irq_init_cb(desc->dev, desc->interrupt_parent);
+			if (ret == -EAGAIN)
+				/*
+				 * Interrupt controller's initialization did not
+				 * complete and should be retried. So let its
+				 * intc_desc be on intc_desc_list.
+				 */
+				continue;
+			list_del(&desc->list);
 			if (ret) {
 				kfree(desc);
 				continue;
@@ -482,7 +491,18 @@ void __init of_irq_init(const struct of_device_id *matches)
 		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
 		if (list_empty(&intc_parent_list) || !desc) {
 			pr_err("of_irq_init: children remain, but no parents\n");
-			break;
+			/*
+			 * If a search with NULL as parent did not result in any
+			 * new parent being found, then the scan for matching
+			 * interrupt controller nodes is considered as complete.
+			 * Otherwise, if there are pending elements on the
+			 * intc_desc_list, then retry this process again with
+			 * NULL as parent.
+			 */
+			if (!parent)
+				break;
+			parent = NULL;
+			continue;
 		}
 		list_del(&desc->list);
 		parent = desc->dev;
