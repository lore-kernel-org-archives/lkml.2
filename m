Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0JGQ7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:59:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0JGQ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EzmZ1eN3lGlLNCawlTLXUEWUawt8euRB36oF12TWVCljdPWBpCWmbCv/IVpSO99QQz
         TRM2oPVZU76YiwmGZ0RbHzLhQuvHHjVnSsCM+ObGfWDGwxlS8RpokNTGtV7yX2G/9kNs
         mtK1C1jq2N89uARpbTRPRvWWtwrjDsR2WJsMM=
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, James Morris <jmorris@namei.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
In-Reply-To: <m1iq1e3qnn.fsf@fess.ebiederm.org>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	 <20101004085913.GR14068@sgi.com>
	 <1286183058.18293.26.camel@edumazet-laptop>
	 <20101004093439.GG5189@cr0.nay.redhat.com>
	 <1286187030.18293.33.camel@edumazet-laptop>
	 <20101004103545.GJ5189@cr0.nay.redhat.com>
	 <1286188701.18293.57.camel@edumazet-laptop>
	 <20101005130117.GK5170@cr0.nay.redhat.com>
	 <20101007071859.GD5471@cr0.nay.redhat.com>
	 <20101007092538.GE5471@cr0.nay.redhat.com>
	 <1286445081.2912.15.camel@edumazet-laptop>
	 <m1iq1e3qnn.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 18:59:03 +0200
Message-ID: <1286470743.2912.276.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 octobre 2010 à 09:37 -0700, Eric W. Biederman a écrit :

> The difference between long handling and int handling is a
> usability issue.  I don't expect we will be exporting new
> vectors via sysctl, so the conversion of a handful of vectors
> from int to long is where this is most likely to be used.
> 
> I skimmed through all of what I presume are the current users
> aka linux-2.6.36-rcX and there don't appear to be any users
> of proc_dounlongvec_minmax that use it's vector properties there.
> 
> Which doubly tells me that incrementing the min and max pointers
> is not what we want to do.
> 

Thats fine by me, thanks Eric.

Andrew, please remove previous patch from your tree and replace it by
following one :

[PATCH v2] sysctl: fix min/max handling in __do_proc_doulongvec_minmax()

When proc_doulongvec_minmax() is used with an array of longs,
and no min/max check requested (.extra1 or .extra2 being NULL), we
dereference a NULL pointer for the second element of the array.

Noticed while doing some changes in network stack for the "16TB problem"

Fix is to not change min & max pointers in
__do_proc_doulongvec_minmax(), so that all elements of the vector share
an unique min/max limit, like proc_dointvec_minmax().

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..8e45451 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2485,7 +2485,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 		kbuf[left] = 0;
 	}
 
-	for (; left && vleft--; i++, min++, max++, first=0) {
+	for (; left && vleft--; i++, first=0) {
 		unsigned long val;
 
 		if (write) {


