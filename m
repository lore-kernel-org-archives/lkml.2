Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2EBOya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:54:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49459 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab2EBOyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:54:17 -0400
Date: Wed, 2 May 2012 15:54:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Validate UEFI boot variables
Message-ID: <20120502145412.GA20058@srcf.ucam.org>
References: <1335816690-26019-1-git-send-email-mjg@redhat.com>
 <1335816690-26019-2-git-send-email-mjg@redhat.com>
 <1335930906.8274.97.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335930906.8274.97.camel@deadeye>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 04:55:06AM +0100, Ben Hutchings wrote:

> This validation is crap; you're not accounting for the size of the node
> or invalid lengths.  Try:

Good catch.

> Isn't this slightly too restrictive?  The '& 0xff' results in many
> non-ASCII characters aliasing hex digits and potentially causes a
> variable to be validated as if it was special.  I would think the
> correct condition is:

Mm. Yeah, I guess that should probably be permitted.

> 		if (var->VariableName[i] > 127 ||
> 		    hex_to_bin(var->VariableName[i]) < 0)
> 
> Presumably the variable should also be ignored if there are any more
> characters after the 4 hex digits?

The spec doesn't permit any such names, so I don't think it makes any 
difference in practice. But in theory, we should probably either 
explicitly permit or reject them rather than treating them as if they're 
boot variables.

> > +	/* A valid entry must be at least 6 bytes */
> > +	if (len < 6)
> > +		return false;
> 
> Surely 8 bytes - otherwise you don't even have space for the
> description's null terminator.

Yes, I guess that could trip things up.

> > +	filepathlength = buffer[4] | buffer[5] << 8;
> > +
> > +	/*
> > +	 * There's no stored length for the description, so it has to be
> > +	 * found by hand
> > +	 */
> > +	desclength = utf16_strsize((efi_char16_t *)(buffer + 6), len) + 2;
> [...]
> 
> Second argument should be len - 6.

Sure.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
