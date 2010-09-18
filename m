Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0IRCjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 22:39:53 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52098 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0IRCjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 22:39:52 -0400
Message-ID: <4C9427B6.9050404@cs.wisc.edu>
Date: Fri, 17 Sep 2010 21:45:10 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Joe Eykholt <jeykholt@cisco.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number
 to atomic_t
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org> <4C93BB8E.2080501@cisco.com>
In-Reply-To: <4C93BB8E.2080501@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 02:03 PM, Joe Eykholt wrote:
>
> How about instead of adding use_serial_number, let's just have the
> drivers that want a serial number call scsi_cmd_get_serial()

I think this sounds better.

You could also convert drivers to the host tagging if you needed a 
unique id for each command sent to a host.

> and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
> used in debug messages in some drivers.  I didn't find other usages
> but didn't do an exhaustive search.

The comments for serial_number say that it is only supposed to be used 
for debugging printks and most drivers use it for that. However, it 
looks like mpt and dpt_i2o are using it for error handling and/or lookup 
type of operations. I think the mpt* uses are not needed in the abort 
checks.

And eata is using it for ordering and tracking or something. It could 
probably be converted to the host tagging if or what you suggested if it 
needs the uniqueue id.

zfcp looks like it copies it. It does not look like the driver needs it.

scsi_error.c uses it in scsi_try_to_abort_cmd to check if a command has 
completed, but I think that can be done by checking if REQ_ATOM_COMPLETE 
is set.
