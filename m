Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2HTQjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:39:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:29300 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2HTQjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,797,1336374000"; 
   d="scan'208";a="206596391"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Denis Efremov <yefremov.denis@gmail.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Jesper Juhl <jj@chaosbits.net>,
        "<target-devel@vger.kernel.org>" <target-devel@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<ldv-project@ispras.ru>" <ldv-project@ispras.ru>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [PATCH] tcm_fc: rcu_deref outside rcu lock/unlock section
Thread-Topic: [PATCH] tcm_fc: rcu_deref outside rcu lock/unlock section
Thread-Index: AQHNfTpQLg4MfL/T/0++Eqja2anUSpdgnnCAgALBHgA=
Date: Mon, 20 Aug 2012 16:39:14 +0000
Message-ID: <B9B2747B-70B2-4E77-A3DA-C6970F1EE66E@intel.com>
References: <1345291831-5086-1-git-send-email-yefremov.denis@gmail.com>
 <1345329331.25161.367.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1345329331.25161.367.camel@haakon2.linux-iscsi.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.82.74]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22FE8813B1DD2944940D10BD3B0AD039@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 18, 2012, at 3:35 PM, Nicholas A. Bellinger wrote:

> On Sat, 2012-08-18 at 16:10 +0400, Denis Efremov wrote:
>> Use rcu_dereference_protected in order to prevent lockdep
>> complaint. Sequel of the patch 863555be
>> 
>> Found by Linux Driver Verification project (linuxtesting.org).
>> 
>> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
>> ---
>> drivers/target/tcm_fc/tfc_sess.c |    4 +++-
>> 1 files changed, 3 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
>> index 87901fa..3c9e5b5 100644
>> --- a/drivers/target/tcm_fc/tfc_sess.c
>> +++ b/drivers/target/tcm_fc/tfc_sess.c
>> @@ -456,7 +456,9 @@ static void ft_prlo(struct fc_rport_priv *rdata)
>> 	struct ft_tport *tport;
>> 
>> 	mutex_lock(&ft_lport_lock);
>> -	tport = rcu_dereference(rdata->local_port->prov[FC_TYPE_FCP]);
>> +	tport = rcu_dereference_protected(rdata->local_port->prov[FC_TYPE_FCP],
>> +					  lockdep_is_held(&ft_lport_lock));
>> +
>> 	if (!tport) {
>> 		mutex_unlock(&ft_lport_lock);
>> 		return;
> 
> This looks OK to silence lockdep.  CC'ing MDR + Kiran for good measure
> here, and will move from target-pending queue -> master with their ACK.
> 
> Thanks Dennis!
> 
> --nab


Ack. In fact I wonder why I didn't encounter it myself.

-- 
Mark Rustad, LAN Access Division, Intel Corporation

