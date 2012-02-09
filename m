Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2BIChP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:37:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2BIChM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:37:12 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=NKm62CkMpMoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=yTfbL28h5xqK1b_hpPEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328755030.2200.133.camel@gandalf.stny.rr.com>
Subject: Re: linux-next: Tree for Feb 2 (trace/events/sunrpc.h)
From: Steven Rostedt <rostedt@goodmis.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 08 Feb 2012 21:37:10 -0500
In-Reply-To: <4F2AD18D.9030904@xenotime.net>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
	 <4F2AD18D.9030904@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added the person responsible for this ]

On Thu, 2012-02-02 at 10:10 -0800, Randy Dunlap wrote:
> On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20120201:
> 
> 
> 
> include/trace/events/sunrpc.h:69:1: error: implicit declaration of function 'rpc_qname'
> include/trace/events/sunrpc.h:69:1: warning: format '%s' expects type 'char *', but argument 9 has type 'int'

This has actually nothing to do with the tracepoint itself. The bug is
with the rpc_qname().

The tracepoint references rpc_qname() and in
include/linux/sunrpc/sched.h:


#ifdef RPC_DEBUG
static inline const char * rpc_qname(const struct rpc_wait_queue *q)
{
	return ((q && q->name) ? q->name : "unknown");
}
#endif

Your config had RPC_DEBUG not set, thus the function was not defined.


The below patch fixes the problem with the side effect that the trace
data will contain "unknown" for all references to rcu_qname().

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index f7b2df5..c89ba95 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -275,6 +275,11 @@ static inline const char * rpc_qname(const struct rpc_wait_queue *q)
 {
 	return ((q && q->name) ? q->name : "unknown");
 }
+#else
+static inline const char * rpc_qname(const struct rpc_wait_queue *q)
+{
+	return "unknown";
+}
 #endif
 
 #endif /* _LINUX_SUNRPC_SCHED_H_ */


