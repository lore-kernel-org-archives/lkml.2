Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1LENHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:07:43 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46123 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1LENHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:07:41 -0500
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org
Date: Mon, 05 Dec 2011 08:03:55 -0500
In-Reply-To: <4EDC9726.1040801@polito.it>
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it>
	 <1321450690.1901.24.camel@falcor> <4EC3CA9A.3070401@polito.it>
	 <4EC40682.2050602@linux.vnet.ibm.com> <4EC4E89F.2060608@polito.it>
	 <1321564518.21708.63.camel@falcor> <4EC63302.4040006@polito.it>
	 <1321637471.2158.44.camel@falcor> <4ECA6595.7010406@polito.it>
	 <1323041763.2061.22.camel@falcor> <4EDC9726.1040801@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323090236.2061.63.camel@falcor>
Mime-Version: 1.0
x-cbid: 11120513-5518-0000-0000-000000CE8E57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 11:04 +0100, Roberto Sassu wrote:

> Hi Mimi
> 
> i think moving this logic to the TPM driver (or in general, delaying
> the action after the list mutex is unlocked) is not safe, because in
> this way you are relying on the kernel trustworthiness to protect
> itself and IMA against unmeasured potential attacks. So, the verifier
> is unable to detect a kernel tampering that removed the limitation
> on the TPM Quote operation.
> 
> What i'm proposing in the patch:
> 
> https://lkml.org/lkml/2011/11/21/202
> 
> is in fact a new extension, which is triggered by a new kernel
> parameter, so that the behaviour of the base IMA is not modified.

How/why the TPM fails is important.  If the TPM fails because of an
intermittent problem, then your solution of denying read/execute could
work, but what would happen if it was persistent?  Would you be able to
quiesce the system?

As there is no way of differentiating a persistent from intermittent
failure, both need to be addressed in the same manor.  For persistent
TPM failure, we can not access the TPM to modify the PCR.  So what
options do we have left?  My suggestion, though not optimal, prevents
the IMA PCR from being quoted.

>From ima_queue.c: ima_add_template_entry()

        result = ima_pcr_extend(digest);
        if (result != 0) {
                audit_cause = "TPM error";
                audit_info = 0;
        }
out:
        mutex_unlock(&ima_extend_list_mutex);

Either in ima_pcr_extend() itself or as a new call, set a flag of some
sort to prevent the TPM dd from quoting the IMA PCR.

I'm open to other suggestions.

> Instead, regardless of this patch, we should fix the memory leaks and
> the memory reference errors as it has been proposed in the patch 2/2 of 
> this set.
> 
> Roberto Sassu

Please separate bug fixes from any other changes.

thanks,

Mimi

