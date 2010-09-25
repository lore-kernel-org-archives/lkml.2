Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0IYC1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:27:13 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43334 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0IYC1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:27:12 -0400
Message-ID: <4C9D5F18.8080809@cs.wisc.edu>
Date: Fri, 24 Sep 2010 21:31:52 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Mike Anderson <andmike@linux.vnet.ibm.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Joe Eykholt <jeykholt@cisco.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number
 to atomic_t
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org> <4C93BB8E.2080501@cisco.com> <4C9427B6.9050404@cs.wisc.edu> <1284839878.13344.300.camel@haakon2.linux-iscsi.org> <1285278389.1849.199.camel@haakon2.linux-iscsi.org> <4C9C4604.1020804@kernel.dk> <20100924183305.GA15128@linux.vnet.ibm.com>
In-Reply-To: <20100924183305.GA15128@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 01:33 PM, Mike Anderson wrote:
> In reviewing the current code paths wasn't the serial_number also used to
> avoid calling __scsi_try_to_abort_cmd for START_UNIT case also.

You mean from scsi_eh_try_stu....->__scsi_try_to_abort_cmd? How does it 
work for that case or what is the code path? Is it when it is called 
from the sas code through scsi_eh_ready_devs?


>
> If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE is set it would
> be correct for the scsi_decide_disposition cases but it would appear this
> would stop __scsi_try_to_abort_cmd from being called in the time out
> case as REQ_ATOM_COMPLETE is set prior to calling blk_rq_timed_out.
>
> 1.) Request timed out path to scsi_eh_scmd_add.
>
> blk_rq_timed_out_timer
> 	...
> 	if (blk_mark_rq_complete(rq))
> 		continue;
> 	blk_rq_timed_out
> 		q->rq_timed_out_fn "scsi_times_out"
> 			scsi_times_out
> 				scsi_eh_scmd_add
>

You are right.
