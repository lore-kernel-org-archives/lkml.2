Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1JDOmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:42:16 -0400
Received: from kanga.kvack.org ([205.233.56.17]:57775 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab1JDOmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:42:16 -0400
Date: Tue, 4 Oct 2011 10:42:15 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jon Mason <mason@myri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
Message-ID: <20111004144215.GE19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com> <20111003215547.GA3107@myri.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003215547.GA3107@myri.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:55:48PM -0500, Jon Mason wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> When configuring the PCIe settings for "performance", we allow parents
> to have a larger Max Payload Size than children and rely on children
> Max Read Request Size to not be larger than their own MPS to avoid
> having the host bridge generate responses they can't cope with.

I'm pretty sure that simply will not work, and is an incorrect understanding 
of how PCIe bridges and devices interact with regards to transaction size 
limits.  Here's why: I am actually implementing a PCIe nic on an FPGA at 
present, and have just been in the process of tuning how memory read 
requests are issued and processed.  It is perfectly valid for a PCIe 
endpoint to issue a read request for an entire 4KB block (assuming it 
respects the no 4KB boundary crossings rule), even when the MPS setting 
is only 64 or 128 bytes.  However, the root complex or PCIe bridge *must 
not* exceed the Maximum Payload Size for any completions with data or 
posted writes.  Multiple completions are okay and expected for read 
requests.  If the MPS on the bridge is set to a larger value than 
what all of the endpoints connected to it, the bridge or root complex will 
happily send read completions exceeding the endpoint's MPS.  This can and 
will lead to failure on the parts of endpoints.

		-ben
