Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab2BPLVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:21:13 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46917 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2BPLVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:21:11 -0500
Message-ID: <4F3CE6A1.9050602@bootc.net>
Date: Thu, 16 Feb 2012 11:21:05 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 08/11] firewire-sbp-target: Add sbp_login.{c,h}
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-9-git-send-email-bootc@bootc.net> <20120215220052.040e680a@stein>
In-Reply-To: <20120215220052.040e680a@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 21:00, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> This file contains the implementation of the login, reconnect and logout
>> management ORBs in SBP-2.
>>
>> Signed-off-by: Chris Boot<bootc@bootc.net>
>> Cc: Andy Grover<agrover@redhat.com>
>> Cc: Clemens Ladisch<clemens@ladisch.de>
>> Cc: Nicholas A. Bellinger<nab@linux-iscsi.org>
>> Cc: Stefan Richter<stefanr@s5r6.in-berlin.de>
>> ---
>>   drivers/target/sbp/sbp_login.c |  665 ++++++++++++++++++++++++++++++++++++++++
>>   drivers/target/sbp/sbp_login.h |   14 +
>>   2 files changed, 679 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/target/sbp/sbp_login.c
>>   create mode 100644 drivers/target/sbp/sbp_login.h
>>
>> diff --git a/drivers/target/sbp/sbp_login.c b/drivers/target/sbp/sbp_login.c
>> new file mode 100644
>> index 0000000..74b5eaf
>> --- /dev/null
>> +++ b/drivers/target/sbp/sbp_login.c
>> @@ -0,0 +1,665 @@
>> +/*
>> + * SBP2 target driver (SCSI over IEEE1394 in target mode)
>> + *
>> + * Copyright (C) 2011  Chris Boot<bootc@bootc.net>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software Foundation,
>> + * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>> + */
>> +
>> +#define KMSG_COMPONENT "sbp_target"
>> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>> +
>> +#include<linux/kref.h>
>> +#include<linux/firewire.h>
>> +#include<linux/firewire-constants.h>
>> +#include<linux/slab.h>
>> +
>> +#include<target/target_core_base.h>
>> +#include<target/target_core_fabric.h>
>> +
>> +#include "sbp_base.h"
>> +#include "sbp_management_agent.h"
>> +#include "sbp_login.h"
>> +#include "sbp_target_agent.h"
>> +
>> +#define SESSION_MAINTENANCE_INTERVAL HZ
>> +
>> +static atomic_t login_id = ATOMIC_INIT(0);
>> +
>> +static void session_maintenance_work(struct work_struct *work);
>> +
>> +static int read_peer_guid(u64 *guid, const struct sbp_management_request *req)
>> +{
>> +	int ret;
>> +	__be32 high, low;
>> +
>> +	ret = fw_run_transaction(req->card, TCODE_READ_QUADLET_REQUEST,
>> +			req->node_addr, req->generation, req->speed,
>> +			(CSR_REGISTER_BASE | CSR_CONFIG_ROM) + 3 * 4,
>> +			&high, sizeof(high));
>> +	if (ret != RCODE_COMPLETE)
>> +		return ret;
>> +
>> +	ret = fw_run_transaction(req->card, TCODE_READ_QUADLET_REQUEST,
>> +			req->node_addr, req->generation, req->speed,
>> +			(CSR_REGISTER_BASE | CSR_CONFIG_ROM) + 4 * 4,
>> +			&low, sizeof(low));
>> +	if (ret != RCODE_COMPLETE)
>> +		return ret;
>> +
>> +	*guid = (u64)be32_to_cpu(high)<<  32 | be32_to_cpu(low);
>> +
>> +	return RCODE_COMPLETE;
>> +}
>> +
>> +static struct sbp_session *sbp_session_find_by_guid(
>> +	struct sbp_tpg *tpg, u64 guid)
>> +{
>> +	struct se_session *se_sess;
>> +
>> +	spin_lock(&tpg->se_tpg.session_lock);
>> +	list_for_each_entry(se_sess,&tpg->se_tpg.tpg_sess_list, sess_list) {
>> +		struct sbp_session *sess = se_sess->fabric_sess_ptr;
>> +		if (sess->guid == guid) {
>> +			spin_unlock(&tpg->se_tpg.session_lock);
>> +			return sess;
>> +		}
>> +	}
>> +	spin_unlock(&tpg->se_tpg.session_lock);
>> +
>> +	return NULL;
>> +}
>
> Another form to write this would be
>
> static struct sbp_session *sbp_session_find_by_guid(
> 		struct sbp_tpg *tpg, u64 guid)
> {
> 	struct se_session *se_sess;
> 	struct sbp_session *s, *session = NULL;
>
> 	spin_lock(&tpg->se_tpg.session_lock);
> 	list_for_each_entry(se_sess,&tpg->se_tpg.tpg_sess_list, sess_list) {
> 		s = se_sess->fabric_sess_ptr;
> 		if (s->guid == guid) {
> 			session = s;
> 			break;
> 		}
> 	}
> 	spin_unlock(&tpg->se_tpg.session_lock);
>
> 	return session;
> }
>
> But since your function is very small, the dual unlock-and-exit paths are
> not a problem for readability.
>
> As an aside, here is a variation of the theme, though weirdly looking if
> one never came across it before:
>
> static struct sbp_session *sbp_session_find_by_guid(
> 		struct sbp_tpg *tpg, u64 guid)
> {
> 	struct se_session *s;
>
> 	spin_lock(&tpg->se_tpg.session_lock);
> 	list_for_each_entry(s,&tpg->se_tpg.tpg_sess_list, sess_list)
> 		if (s->fabric_sess_ptr->guid == guid)
> 			break;
> 	spin_unlock(&tpg->se_tpg.session_lock);
>
> 	if (&s->sess_list !=&tpg->se_tpg.tpg_sess_list)
> 		return s->fabric_sess_ptr;
> 	else
> 		return NULL;
> }
>
> [...]
>> +static struct sbp_login_descriptor *sbp_login_find_by_id(
>> +	struct sbp_tpg *tpg, int login_id)
>> +{
>> +	struct se_session *se_sess;
>> +
>> +	spin_lock(&tpg->se_tpg.session_lock);
>> +	list_for_each_entry(se_sess,&tpg->se_tpg.tpg_sess_list, sess_list) {
>> +		struct sbp_session *sess = se_sess->fabric_sess_ptr;
>> +		struct sbp_login_descriptor *login;
>> +
>> +		spin_lock(&sess->login_list_lock);
>> +		list_for_each_entry(login,&sess->login_list, link) {
>> +			if (login->login_id == login_id) {
>> +				spin_unlock(&sess->login_list_lock);
>> +				spin_unlock(&tpg->se_tpg.session_lock);
>> +				return login;
>> +			}
>> +		}
>> +		spin_unlock(&sess->login_list_lock);
>> +	}
>> +	spin_unlock(&tpg->se_tpg.session_lock);
>> +
>> +	return NULL;
>> +}
>
> This function on the other hand might indeed benefit from a style
> involving a single unlock-and-exit path.
>
> [...]
>> +static void sbp_session_release(struct sbp_session *sess, bool cancel_work)
>> +{
>> +	spin_lock(&sess->login_list_lock);
>> +	if (!list_empty(&sess->login_list)) {
>> +		spin_unlock(&sess->login_list_lock);
>> +		return;
>> +	}
>> +	spin_unlock(&sess->login_list_lock);
>> +
>> +	transport_deregister_session_configfs(sess->se_sess);
>> +	transport_deregister_session(sess->se_sess);
>> +
>> +	if (sess->card)
>> +		fw_card_put(sess->card);
>> +
>> +	if (cancel_work)
>> +		cancel_delayed_work_sync(&sess->maint_work);
>> +
>> +	kfree(sess);
>> +}
>
> What prevents that an entry is added to sess->login_list right after
> you tested for it being empty?
>
> If there is something external which prevents this, then you don't
> need to take the lock just for this test.
>
> If there is no such external measure of serialization, then the
> spinlock-protected section is too small.

Only two things can manipulate the login list: the management agent, 
which is serialised (e.g. only one management request per target port 
can be ongoing at any point in time), and the session maintenance work 
item. So you're right, the lock-protected section is too small.

> By the way, the use of spin_lock()/spin_unlock() is quite atypical.
> This API restricts you
>    - not to call a possibly sleeping function within the lock-
>      protected section,
>    - not to take the lock in tasklet context or IRQ context.
>
> So this locking API is quite rarely used:  Anywhere where a mutex
> /could/ be used, but none of the locked sections ever need to sleep.
> This is a rather narrow use case.
>
> Maybe you know all this but I thought I mention it anyway.

The session is only really inspected/maniuplated in the context of work 
items, so it's possible I could use mutexes - although in the target 
agent address handler I do check the node_id against the one in the 
session (and I should really check the generation too). Would memory 
barriers be enough for those or would locking be required?

>> +static void session_check_for_reset(struct sbp_session *sess)
>> +{
>> +	bool card_valid = false;
>> +
>> +	if (sess->card) {
>> +		spin_lock_irq(&sess->card->lock);
>> +		card_valid = (sess->card->local_node != NULL);
>> +		spin_unlock_irq(&sess->card->lock);
>> +
>> +		if (!card_valid) {
>> +			fw_card_put(sess->card);
>> +			sess->card = NULL;
>> +		}
>> +	}
>> +
>> +	if (!card_valid || (sess->generation != sess->card->generation)) {
>> +		pr_info("Waiting for reconnect from node: %016llx\n",
>> +			sess->guid);
>> +
>> +		sess->node_id = -1;
>> +		sess->reconnect_expires = get_jiffies_64() +
>> +			((sess->reconnect_hold + 1) * HZ);
>> +	}
>> +}
>
> [Note to self:  When more awake, carefully review this peeking into
> fw_card internals, the generation accesses, and the card refcounting.]
>
>> +static void session_reconnect_expired(struct sbp_session *sess)
>> +{
>> +	struct sbp_login_descriptor *login, *temp;
>> +
>> +	pr_info("Reconnect timer expired for node: %016llx\n", sess->guid);
>> +
>> +	spin_lock(&sess->login_list_lock);
>> +	list_for_each_entry_safe(login, temp,&sess->login_list, link) {
>> +		spin_unlock(&sess->login_list_lock);
>> +		sbp_login_release(login, false);
>> +		spin_lock(&sess->login_list_lock);
>> +	}
>> +	spin_unlock(&sess->login_list_lock);
>> +
>> +	/* sbp_login_release() calls sbp_session_release() */
>> +}
>
> This is wrong.  Either something external protects the
> session_reconnect_expired() executing context from concurrent
> manipulations of sess->login_list.  Then you don't need to
> take the lock here in the first place.
>
> Or there is no such external serialization measure.  Then you
> must not drop the list lock in the loop body.
>
> In the latter case, an easy fix would be to move the expired
> logins to a local temporary list while holding the lock, then
> release each item from the temporary list without holding the
> lock.

Yes deep down I knew it was wrong, and it'll be the latter case of 
needing more locking than it has. I guess I need to protect access to 
the entire session really. Possibly even rwlocks due to only the 
management processes ever changing anything, but lots of reads during 
command handling.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
