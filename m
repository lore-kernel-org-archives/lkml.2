Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0IQQp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:45:56 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:39449 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751679Ab0IQQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:45:54 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: kDo42VQVM1n5gw1OnUFcp6I3InRvvd70cDXPIM5oglFBVt3
 _hB90mD1M1gE865fFdZ5RrzvYU1pz.fkKhFszYDXNtztsrlY2UoMCYen6Gr1
 svtN.rRedtBDAIqpkrtN_t7MzrWL0VfpyUz6ne7joHvTs9Eav7G57DplnX3c
 SuQjjIphR.zp9FUDDz1reqBKztKLU5tUSWHZsJpKtL4R24RRj7xuG_3XIlMP
 yg53B3TVV1lnaEPmxQxACgU2y2ldRO8pVyuwNKm4uWRgvhyHO62c.oSLa
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 1/8] scsi: Drop struct Scsi_Host->host_lock around
	SHT->queuecommand()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
References: <1284676529-10756-1-git-send-email-nab@linux-iscsi.org>
	 <1284691571.26423.50.camel@mulgrave.site>
	 <20100917072022.GB2644@gargoyle.ger.corp.intel.com>
	 <1284725592.26423.60.camel@mulgrave.site>
	 <4C9379AA.4000103@linux.intel.com>
	 <1284735438.26423.81.camel@mulgrave.site>
	 <1284741478.13344.154.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain
Date: Fri, 17 Sep 2010 09:41:44 -0700
Message-Id: <1284741704.13344.157.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 09:37 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2010-09-17 at 10:57 -0400, James Bottomley wrote:
> > On Fri, 2010-09-17 at 16:22 +0200, Andi Kleen wrote:
> > > > I don't disagree with the idea of removing it, especially as it has so
> > > > few users, but replacing the host lock with an atomic here would still
> > > > vastly reduce the contention, which is the initial complaint.  The
> > > 
> > > Actually the complaint is the overhead of the spin lock. This can be 
> > > either caused
> > > by contention or by cache line bounce time.
> > 
> > The original complaint was contention.  My desire is to reduce the
> > locked path coverage, so I saw an opportunity.
> > 
> > What I was actually thinking of for the atomic is that we'd let it range
> > [1..INT_MAX] so a zero was an indicator of no use of this.  Then the
> > actual code could become
> > 
> > if (atomic_read(x)) {
> > 	do {
> > 		y = atomic_add_return(1, x);
> > 	} while (y == 0);
> > }
> 
> The conversion of struct scsi_cmnd->serial_number to atomic_t and the
> above code for scsi_cmd_get_serial() sounds perfectly reasonable to me.
> 

Actually, that should be the conversion of struct
Scsi_Host->cmd_serial_number to an atomic_t.   AFAICT there is no reason
for struct scsi_cmnd->serial_number needing to be an atomic_t.

Best,

--nab


