Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3AJLS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:18:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51420 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab3AJLSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:18:24 -0500
Date: Thu, 10 Jan 2013 12:18:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Message-ID: <20130110111821.GA23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get

net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v1’:
net/netfilter/xt_CT.c:250:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v0’:
net/netfilter/xt_CT.c:112:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

when building 3.8-rc3 here.

And this time, the warnings are real:

static int xt_ct_tg_check_v0(const struct xt_tgchk_param *par)
{
	struct xt_ct_target_info *info = par->targinfo;
	struct nf_conntrack_tuple t;
	struct nf_conn *ct;
	int ret;

	if (info->flags & ~XT_CT_NOTRACK)
		return -EINVAL;

	if (info->flags & XT_CT_NOTRACK) {
		ct = nf_ct_untracked_get();
		atomic_inc(&ct->ct_general.use);
		goto out;
	}

#ifndef CONFIG_NF_CONNTRACK_ZONES
	if (info->zone)
		goto err1;
#endif
...

ret doesn't get initialized and if the first two if-blocks are false and
CONFIG_NF_CONNTRACK_ZONES is not defined (as is in my case) we do "goto
err1":

err1:
        return ret;

which returns an uninitialized 'ret'.

Now, I don't know the code to know whether if (info->zone) is ever true
but someone better check this before subtle bugs start happening.

Ditto for the xt_ct_tg_check_v1() function.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
