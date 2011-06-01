Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab1FAU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:26:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:51607
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab1FAU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:26:42 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1521M1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE6A013.409@freescale.com>
Date: Wed, 1 Jun 2011 15:24:51 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <20110601204618.32190be9@lxorguk.ukuu.org.uk>
In-Reply-To: <20110601204618.32190be9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> +	/* One partition must be local, the other must be remote.  In other
>> +	   words, if source and target are both -1, or are both not -1, then
>> +	   return an error. */
>> +	if ((param.source == -1) == (param.target == -1))
>> +		return -EINVAL;
> 
> Excess brackets (I just mention that one in passing)'

Do you mean excess parentheses?  If so, then I don't see how.  "(param.source ==
-1)" and "(param.target == -1)" are expressions that return a boolean.  I'm
comparing the two boolean results to see if they're equal.  I want to make sure
that the compiler doesn't do something like this:

	if (param.source == (-1 == (param.target == -1)))

I don't even know what that means, but it's not what I want.

>> +static char *strdup_from_user(const char __user *ustr, size_t max)
>> +{
>> +	size_t len;
>> +	char *str;
>> +
>> +	len = strnlen_user(ustr, max);
>> +	if (len > max)
>> +		return ERR_PTR(-ENAMETOOLONG);
>> +
>> +	str = kmalloc(len, GFP_KERNEL);
>> +	if (!str)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (copy_from_user(str, ustr, len))
>> +		return ERR_PTR(-EFAULT);
>> +
>> +	return str;
>> +}
> 
> This belongs on lib/ if its of general use which I think it perhaps is
> and if we don't have one already.

Where exactly in lib/ should it go?  lib/strings.c seems too low-level for a
function like this.  lib/string_helpers.c is for sprintf-like functions.  And
it's too generic for lib/powerpc/

>> +	default:
>> +		pr_debug("fsl-hv: unknown ioctl %u\n", cmd);
>> +		ret = -ENOIOCTLCMD;
> 
> -ENOTTY
> 
> (-ENOIOCTLCMD is an internal indicator designed so driver layers can say
> 'dunno, try the next layer up')
> 
>> +/* Linked list of processes that have us open */
>> +struct list_head db_list;
> 
> static ?
> 
> 
>> + * We use the same interrupt handler for all doorbells.  Whenever a doorbell
>> + * is rung, and we receive an interrupt, we just put the handle for that
>> + * doorbell (passed to us as *data) into all of the queues.
> 
> I wonder if these should be presented as IRQs or whether that makes no
> sense ?

Well, the "handles" are supposed to be just unique numbers.  In this case, they
are IRQs, but we don't want to expose that.  The application is supposed to scan
the device tree looking for the doorbell nodes that it wants, and in those nodes
there is a 'reg' property that contains the handle for that doorbell.  So the
numbers just need to match.  What they represent is not relevant.

>> +static irqreturn_t fsl_hv_state_change_isr(int irq, void *data)
>> +{
>> +	unsigned int status;
>> +	struct doorbell_isr *dbisr = data;
>> +	int ret;
>> +
>> +	/* Determine the new state, and if it's stopped, notify the clients. */
>> +	ret = fh_partition_get_status(dbisr->partition, &status);
>> +	if (!ret && (status == FH_PARTITION_STOPPED))
>> +		schedule_work(&dbisr->work);
>> +
>> +	/* Call the normal handler */
>> +	return fsl_hv_isr(irq, (void *) (uintptr_t) dbisr->doorbell);
>> +}
> 
> Would a threaded IRQ clean this up by avoiding the queue/work stuff ?

Yes, I think so.  V3 coming up.

-- 
Timur Tabi
Linux kernel developer at Freescale

