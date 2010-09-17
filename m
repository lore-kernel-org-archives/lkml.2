Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0IQS2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:28:34 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41222 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754362Ab0IQS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:28:33 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: oz2f_SkVM1mLslfBdfQrk2jWZcrk4Zz51nku3Hv.hKcoymw
 v8ERCMyzhhoSJEja91BI38g0g3JEPili3pXAVmaB52vnbpB6xYvk2i7zQRdS
 LncMfzl1RfwqgavB_i5LmumXdBedpDfxI9QTZXvrYb.V7k9U_PLEz63gyaVt
 wOvuK0H1.UC.WohvoJFSY9jDewdN.NTsaQ2jtbq4sVrHdzB9zooKzAguj6pc
 BXkwKi8I67Q7zT42qYX6nFA0.EJxSMvI8PB12xpNq7U8sAvFMd37nOAoWwQD
 HIIozUPcImj9TWDAv6ex01HNcRgK0UZ9iKmlyphfDC4O7yIWXN3mwdMl7gFV
 f3zXSHWab_X8SBgBZMw--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <4C93B2BC.8000404@garzik.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <1284686949.7280.99.camel@schen9-DESK>
	 <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
	 <4C93B2BC.8000404@garzik.org>
Content-Type: text/plain
Date: Fri, 17 Sep 2010 11:24:23 -0700
Message-Id: <1284747863.13344.167.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 14:26 -0400, Jeff Garzik wrote:
> On 09/16/2010 09:31 PM, Nicholas A. Bellinger wrote:
> > On Thu, 2010-09-16 at 18:29 -0700, Tim Chen wrote:
> >> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger<nab@linux-iscsi.org>
> >>>
> >>> Greetings all,
> >>>
> >>> This series contains the first round of a whole-sale conversion for droping
> >>> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> >>> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> >>> that is protected by host_lock is scsi_cmd_get_serial)_.
> >>>
> >>
> >> Maybe we can change the host->cmd_serial_number to atomic and totally
> >> avoid the need to take host_lock.
> >
> > Hmmmm good point, then we would also need an atomic_t for signaling
> > (shost_state == SHOST_DEL) in scsi_dispatch_cmd() to be able to
> > completly drop host_lock usage within scsi_dispatch_cmd().
> >
> > I can take a look at doing this specific part, if you would be willing
> > to have a look at the host->cmd_serial_number conversion piece.  ;)
> 
> But that raises the familiar tale of:  using multiple atomics (w/ their 
> locked instructions) may cost more than a spinlock.

So patch #1 in the v2 series just posted uses the following code:

static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
{
        /*
         * The use of per struct scsi_cmnd->serial_number is disabled by default
         */
        if (!(host->use_serial_number))
                return;
        /*
         * Increment the host->cmd_serial_number by 2 so cmd->serial_number
         * is always odd and wraps to 1 instead of 0.
         */
        cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
}


Note that host->use_serial_number is disabled by default, so for the typical case
no atomic_t reading (or writing) is required.

Best,

--nab


