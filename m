Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0G3RSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:32 -0400
Received: from kroah.org ([198.145.64.141]:51444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0G3RST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:03 2010
Message-Id: <20100730171503.300185868@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Wegener <sven.wegener@stealer.net>,
        Simon Horman <horms@verge.net.au>, Patrick McHardy <kaber@trash.net>
Subject: [040/165] ipvs: Add missing locking during connection table hashing and unhashing
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

commit aea9d711f3d68c656ad31ab578ecfb0bb5cd7f97 upstream.

The code that hashes and unhashes connections from the connection table
is missing locking of the connection being modified, which opens up a
race condition and results in memory corruption when this race condition
is hit.

Here is what happens in pretty verbose form:

CPU 0					CPU 1
------------				------------
An active connection is terminated and
we schedule ip_vs_conn_expire() on this
CPU to expire this connection.

					IRQ assignment is changed to this CPU,
					but the expire timer stays scheduled on
					the other CPU.

					New connection from same ip:port comes
					in right before the timer expires, we
					find the inactive connection in our
					connection table and get a reference to
					it. We proper lock the connection in
					tcp_state_transition() and read the
					connection flags in set_tcp_state().

ip_vs_conn_expire() gets called, we
unhash the connection from our
connection table and remove the hashed
flag in ip_vs_conn_unhash(), without
proper locking!

					While still holding proper locks we
					write the connection flags in
					set_tcp_state() and this sets the hashed
					flag again.

ip_vs_conn_expire() fails to expire the
connection, because the other CPU has
incremented the reference count. We try
to re-insert the connection into our
connection table, but this fails in
ip_vs_conn_hash(), because the hashed
flag has been set by the other CPU. We
re-schedule execution of
ip_vs_conn_expire(). Now this connection
has the hashed flag set, but isn't
actually hashed in our connection table
and has a dangling list_head.

					We drop the reference we held on the
					connection and schedule the expire timer
					for timeouting the connection on this
					CPU. Further packets won't be able to
					find this connection in our connection
					table.

					ip_vs_conn_expire() gets called again,
					we think it's already hashed, but the
					list_head is dangling and while removing
					the connection from our connection table
					we write to the memory location where
					this list_head points to.

The result will probably be a kernel oops at some other point in time.

This race condition is pretty subtle, but it can be triggered remotely.
It needs the IRQ assignment change or another circumstance where packets
coming from the same ip:port for the same service are being processed on
different CPUs. And it involves hitting the exact time at which
ip_vs_conn_expire() gets called. It can be avoided by making sure that
all packets from one connection are always processed on the same CPU and
can be made harder to exploit by changing the connection timeouts to
some custom values.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/ipvs/ip_vs_conn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -146,6 +146,7 @@ static inline int ip_vs_conn_hash(struct
 	hash = ip_vs_conn_hashkey(cp->af, cp->protocol, &cp->caddr, cp->cport);
 
 	ct_write_lock(hash);
+	spin_lock(&cp->lock);
 
 	if (!(cp->flags & IP_VS_CONN_F_HASHED)) {
 		list_add(&cp->c_list, &ip_vs_conn_tab[hash]);
@@ -158,6 +159,7 @@ static inline int ip_vs_conn_hash(struct
 		ret = 0;
 	}
 
+	spin_unlock(&cp->lock);
 	ct_write_unlock(hash);
 
 	return ret;
@@ -177,6 +179,7 @@ static inline int ip_vs_conn_unhash(stru
 	hash = ip_vs_conn_hashkey(cp->af, cp->protocol, &cp->caddr, cp->cport);
 
 	ct_write_lock(hash);
+	spin_lock(&cp->lock);
 
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
 		list_del(&cp->c_list);
@@ -186,6 +189,7 @@ static inline int ip_vs_conn_unhash(stru
 	} else
 		ret = 0;
 
+	spin_unlock(&cp->lock);
 	ct_write_unlock(hash);
 
 	return ret;


