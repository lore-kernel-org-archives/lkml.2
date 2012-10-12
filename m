Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2JLU5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:57:01 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33769 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab2JLU5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:57:00 -0400
Date: Fri, 12 Oct 2012 14:56:58 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20121012205658.GM4124@obsidianresearch.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
 <20121010163324.GB5013@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010163324.GB5013@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:33:24AM -0500, Kent Yoder wrote:
> On Sun, Sep 30, 2012 at 05:33:45PM -0600, Jason Gunthorpe wrote:
> > How to use the TPM is really a user space policy choice, if the
> > environment wants to use middleware then fine, but it is possible to
> > make correct TPM apps without using middleware.
> 
>   I'm not sure how I feel about this. The single open rule doesn't
> prevent replacement of the middleware, it just requires a
> open()/close()

I'm not interested in replacing the middleware, our designs do not use
any middleware and several processes are required to access the TPM at
once.

Using open/close is an interesting idea, but it wouldn't work. open()
is coded to return EBUSY if another process has it open, rather than
block, and spinning on open would be unacceptable.

> around any use of the device node. That seems simple enough to me. In
> places where you do want TSS to be the sole opener, it can't enforce
> that rule itself, so I think we need to preserve the option of a single
> open at a minimum.

I agree, but I'm not sure how to expose this function? I've seen other
places abuse O_EXCL for this, but that would not be compatible with
existing implementations.

Three things come to mind
 - O_EXCL means the open only succeeds if it the only open and
   prevents others (not compatible)
 - Some other O_ flag is hijacked to mean the opposite of the above
   (yuk)
 - A sysfs flag is added to turn on the new O_EXCL behavior

What do you think?

Jason
