Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0HZTtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:49:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33489 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0HZTtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:49:19 -0400
Message-ID: <4C76C518.6030301@zytor.com>
Date: Thu, 26 Aug 2010 12:48:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 01/10] x86/iommu: Add IOMMU_INIT macros, .iommu_table
 section, and iommu_table_entry structure.
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com> <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com> <20100826181913.GA5947@merkur.ravnborg.org>
In-Reply-To: <20100826181913.GA5947@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 11:19 AM, Sam Ravnborg wrote:
> 
> So we have yet another magic section in vmlinux.lds.S
> A nice comemnt that expalins what this is used for and why
> it is discardable etc. would be nice.
> 
> Lots of magic sections in same file miss this,
> but thats not an example to follwow.
> 

Honestly, I think we this kind of problem -- a mergeable table -- often
enough that we should implement a generic facility for it.  It obviously
has to be based on sections, but I think we could automate its creation.
 The gPXE people have done that, and this is more or less a summary of
their technique.

Basically, you have a set of sections with names like:

	.table.<symbol>.<priority>

... then the linker script looks something like:

	.table : {
		SORT_BY_NAME(.table.*)
	}

use SORT_BY_NAME() in the linker script.  To get the start and end
symbols, we define them as solo symbols inside sections designed to sort
first and last (written by hand into email, so adjustments may be
needed, void where prohibited):

#define TABLE(name, priority) \
	__section(".table." ## name ## "." ## priority)

#define DECLARE_TABLE(type, name) \
	extern type __table ## name ## _start[0]; \
	extern type __table ## name ## _end[0];

#define DEFINE_TABLE(type, name) \
	type __table ## name ## _start[0] TABLE(name, 0); \
	type __table ## name ## _end[0] TABLE(name, 9);

Here "priority" is a digit from 1 (first) to 8 (last); 0 and 9 are used
for the capstones.

Presumably we need a few different flavors for init tables and so on,
but this would make it a generic mechanism.

	-hpa
