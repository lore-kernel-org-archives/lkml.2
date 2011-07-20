Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1GTPWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:22:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1GTPWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:22:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LB4rOzfqSiHQPVU47S70XhdrLsDpkavZUx8BJxLNyJ58HM/UKO4buIOFVRUEmM6sh
	P2fe3SiBfANgLKZGE8UBQ==
MIME-Version: 1.0
In-Reply-To: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 20 Jul 2011 09:22:31 -0600
Message-ID: <CAErSpo5-PrZ-do7HqM=2zV8cGibj0bkpFaHtmeRUJmMRZGfTWw@mail.gmail.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 2:09 AM, Huang Ying <ying.huang@intel.com> wrote:
> EINJ parameter support is only usable for some specific BIOS.
> Originally, it is expected to have no harm for BIOS does not support
> it.  But now, we found it will cause issue (memory overwriting) for
> some BIOS.  So param support is disabled by default and only enabled
> when newly added module parameter named "param_extension" is
> explicitly specified.

Adding parameters always makes things harder for users.  Is there any
way this could be done with a whitelist or other automatic mechanism?

Per 6e320ec1d98 (which added EINJ parameter support), parameters are
an unpublished extension and are not part of the ACPI spec.  So if we
pick up an MMIO address from a SET_ERROR_TYPE WRITE_REGISTER
instruction and blindly fill in a structure (undefined by the spec)
presumed to be at that address, it doesn't seem surprising that things
will blow up on BIOSes that don't expect that behavior.  After all,
the spec says to write to a generic address structure (not an
einj_parameter structure) when we interpret the WRITE_REGISTER
instruction (not at the magic time between SET_ERROR_TYPE and
EXECUTE_OPERATION).

If EINJ parameter support is ever added to the ACPI spec, I would
expect a new EINJ flag bit or similar indication to be added at the
same time, so the OS would know when to use it.

Can you add a whitelist of BIOSes that do support this extension?
Maybe you could define a GUID that future platforms could supply so
you wouldn't have to update the whitelist for every new platform that
supports it?

Bjorn
