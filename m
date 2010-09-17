Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0IQRsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:48:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:56979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab0IQRsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:48:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,383,1280732400"; 
   d="scan'208";a="838640431"
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
 SHT->queuecommand()
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1284741704.13344.157.camel@haakon2.linux-iscsi.org>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
	 <1284725592.26423.60.camel@mulgrave.site>
	 <4C9379AA.4000103@linux.intel.com>
	 <1284735438.26423.81.camel@mulgrave.site>
	 <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
	 <1284741704.13344.157.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 10:49:59 -0700
Message-ID: <1284745799.7280.155.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 09:41 -0700, Nicholas A. Bellinger wrote:

> > > 
> > > What I was actually thinking of for the atomic is that we'd let it range
> > > [1..INT_MAX] so a zero was an indicator of no use of this.  Then the
> > > actual code could become
> > > 
> > > if (atomic_read(x)) {
> > > 	do {
> > > 		y = atomic_add_return(1, x);
> > > 	} while (y == 0);
> > > }
> > 
> > The conversion of struct scsi_cmnd->serial_number to atomic_t and the
> > above code for scsi_cmd_get_serial() sounds perfectly reasonable to me.
> > 
> 
> Actually, that should be the conversion of struct
> Scsi_Host->cmd_serial_number to an atomic_t.   AFAICT there is no reason
> for struct scsi_cmnd->serial_number needing to be an atomic_t.

Just want to verify the hidden assumption we have here when the atomic
int Scsi_Host->cmd_serial_number counter overflow after increment. The
counter itself then becomes negative.  We are assuming that when we do
type conversion back to unsigned long scsi_cmnd->serial_number, we will
get the right thing.  

So for 32-bit int, we expect if we start with 0x7fffffff in hex and the
expected sequence will be

	2147483647 (int) -> 2147483647 (unsigned long)  [0x7fffffff]
	+1
	-2147483648 (int) -> 2147483648 (unsigned long) [0x80000000]
	+1
	-2147483647 (int) -> 2147483649 (unsigned long) [0x80000001]
	
If there is architecture where the above assumption is not true (which
I'm not aware of but just checking), then we should manually wrap the
atomic counter to 1 when counter overflow.  

Tim
		
		

