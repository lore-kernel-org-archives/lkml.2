Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0KIPSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:18:51 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:37826 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0KIPSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:18:47 -0500
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
From: David Safford <safford@watson.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20101109064016.GF16307@obsidianresearch.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289230246-3856-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101108170937.GA31501@obsidianresearch.com>
	 <1289240313.6060.10.camel@localhost.localdomain>
	 <20101109064016.GF16307@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 10:17:18 -0500
Message-ID: <1289315838.16976.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 23:40 -0700, Jason Gunthorpe wrote:
> It just seems like really odd functionality. I'm not familiar with the
> KH api, but is there any chance now (or in future) that non-root could
> access this function?

good point - we really should explicitly require CAP_SYS_ADMIN for
pcrlock to be safe. Willdo.

> A few random observations
>  - I'm sure someone will say kdoc format should be used for those
>    function comments?

that's not required for static functions.

>  - Using a random value to extend the PCR effectively wastes it
>    and creates a tiny risk the random extend could result in 0.

2^-160? And using a fixed value, or one under user control
would be worse.

>  - It would be nice to formally state the datablob is a
>    TPM_STORED_DATA with no embellishments. The expectation is
>    userspace can validate the sealInfo prior to loading the
>    key.

It's not obvious from the code? :-) Will clarify in comments.

(It also needs to be documented somewhere in some userspace 
documentation. We will be posting trusted key userspace utilities 
(such as for generating/inspecting pcrinfo blobs and fields in 
sealed blobs), and will certainly document it there too. Perhaps 
the trusted keys information should be added to keyctl or a new
man page too?)

>  - I'm unclear on the merits of using raw random data from the TPM.
>    I'd feel much better if this was mixed with random
>    from the kernel pool too. Ideally using a FIPS DBRNG transform..

The TPM's have a FIPS certified random number generator, which must
pass a power-on self test before it is used. I have done extensive
DieHard tests on various TPM chips, and they have all passed, showing
in my tests unmeasurable correlation. Particularly at boot time, I
trust the TPM random numbers more than the kernel pool, which has
not yet been reseeded or had time to accumulate much entropy.

>  - Shouldn't all the TPM RPC functions live together in the TPM code
>    someplace? You've done a good job of adding many more general
>    primitives to build RPC's with.
>    FWIW, last time I worked with TPMs I built a RPC code generator
>    for this stuff, which if any more are added would be a really smart
>    direction to head in.

The seal and unseal are now pretty general, and could be moved to 
the TPM code, but unless there are other kernel users of the functions,
they might as well stay static and with the trusted key code, since
that's the only place they are being used. Easy enough to move and
make public later if someone wants them...

dave

