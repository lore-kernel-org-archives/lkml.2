Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2HRWfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:35:37 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:52047 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2HRWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:35:34 -0400
Subject: Re: [PATCH] tcm_fc: rcu_deref outside rcu lock/unlock section
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Jesper Juhl <jj@chaosbits.net>, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru,
        "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
In-Reply-To: <1345291831-5086-1-git-send-email-yefremov.denis@gmail.com>
References: <1345291831-5086-1-git-send-email-yefremov.denis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Aug 2012 15:35:31 -0700
Message-ID: <1345329331.25161.367.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 16:10 +0400, Denis Efremov wrote:
> Use rcu_dereference_protected in order to prevent lockdep
> complaint. Sequel of the patch 863555be
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  drivers/target/tcm_fc/tfc_sess.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 87901fa..3c9e5b5 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -456,7 +456,9 @@ static void ft_prlo(struct fc_rport_priv *rdata)
>  	struct ft_tport *tport;
>  
>  	mutex_lock(&ft_lport_lock);
> -	tport = rcu_dereference(rdata->local_port->prov[FC_TYPE_FCP]);
> +	tport = rcu_dereference_protected(rdata->local_port->prov[FC_TYPE_FCP],
> +					  lockdep_is_held(&ft_lport_lock));
> +
>  	if (!tport) {
>  		mutex_unlock(&ft_lport_lock);
>  		return;

This looks OK to silence lockdep.  CC'ing MDR + Kiran for good measure
here, and will move from target-pending queue -> master with their ACK.

Thanks Dennis!

--nab

