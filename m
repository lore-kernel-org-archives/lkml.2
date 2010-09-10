Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0IJTR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 15:17:58 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:30148 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751618Ab0IJTR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 15:17:57 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: NsikUZoVM1nk7XC5slg.oVmpxb9BLvL6nrFUgSOVQKGl_1n
 9l5wMLf5Sn56njR9ReMDX42yR04q00AlW9kGbFLKPqjr4xihvuiFXuXhgG6d
 I6RLBv5FNnlRVl1vM0aP.7_ceQ3LZK.r1yiinG44YGfoMt2wDjQ9PIA7Jj9m
 MDdogJBg34BvrLi0iHw_D9v7FIra3KftGMTVLzBbb2LGvSLYuw2l4NbgC3wS
 tc6tIVAUwLpPlo2JXuzEXTQ6hQMtHa_F6e2dgPFNlt14.YSpVLZWoumikWvj
 rKTxu58_aeRIPXNnKwqYx0WaQ1I361PgMU4azBdSNrp9viqvLCWeo9hqs8rX
 9M287NI.8fNToLyTUfw--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] tcm: Convert to cpu_relax() for atomic_read() in tight
	loops
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <4C89D0E0.4000803@gmail.com>
References: <1284067768-23863-1-git-send-email-nab@linux-iscsi.org>
	 <4C89D0E0.4000803@gmail.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 12:13:50 -0700
Message-Id: <1284146030.19890.77.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 08:32 +0200, Jiri Slaby wrote:
> On 09/09/2010 11:29 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This patch converts the following functions from within shutdown and release
> > path code to use cpu_relax() instead of msleep() while doing atomic_read() in
> > a tight loop waiting for various PR and MIB reference count(s) to return to zero:
> > 
> > 	*) core_update_device_list_for_node() + struct se_dev_entry->pr_ref_count
> > 	*) core_release_port() + struct se_port->sep_tg_pt_ref_cnt
> > 	*) se_dev_stop() + struct se_hba->dev_mib_access_count
> > 	*) __core_scsi3_free_registration() + struct t10_pr_registration->pr_res_holders
> > 	*) core_tpg_wait_for_nacl_pr_ref() + struct se_node_acl->acl_pr_ref_count
> > 	*) core_tpg_wait_for_mib_ref() + struct se_node_acl->mib_ref_count
> > 	*) core_tpg_deregister() + struct se_portal_group->tpg_pr_ref_count
> > 	*) transport_deregister_session() + struct se_session->mib_ref_count
> > 
> > Thanks to Konrad Rzeszutek Wilk for mentioning cpu_relax() usage!
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_device.c    |    6 +++---
> >  drivers/target/target_core_pr.c        |    2 +-
> >  drivers/target/target_core_tpg.c       |    6 +++---
> >  drivers/target/target_core_transport.c |    2 +-
> >  4 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> > index 665b8e2..459f0f8 100644
> > --- a/drivers/target/target_core_device.c
> > +++ b/drivers/target/target_core_device.c
> > @@ -532,7 +532,7 @@ int core_update_device_list_for_node(
> >  	 */
> >  	spin_unlock_irq(&nacl->device_list_lock);
> >  	while (atomic_read(&deve->pr_ref_count) != 0)
> > -		msleep(100);
> > +		cpu_relax();
> >  	spin_lock_irq(&nacl->device_list_lock);
> >  	/*
> >  	 * Disable struct se_dev_entry LUN ACL mapping
> 
> Why would you want to convert those to busy-waiting? This should rather
> be converted to wait_event/wake_up, right?

Hi Jiri,

I agree that this is the one scenario within the msleep() -> cpu_relax()
conversion patch that involves something besides a simple shortly held
'non CDB I/O emulation path context ref/deref', and might probably be
better served by using wait_event/wake_up.

I will take a look at a conversion to use wait_queue_head_t in the near
future.

Thanks for your comments Jiri!

--nab


