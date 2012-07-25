Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2GYAfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:35:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34451 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GYAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:35:15 -0400
Date: Tue, 24 Jul 2012 21:35:07 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Masatake YAMATO <yamato@redhat.com>
Cc: andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v4 1/8] bluetooth: /proc/net/ entries for bluetooth
 protocols
Message-ID: <20120725003507.GR20029@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Masatake YAMATO <yamato@redhat.com>,
	andrei.emeltchenko.news@gmail.com, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120711112308.GA3044@aemeltch-MOBL1>
 <20120711.211906.1087916687452547370.yamato@redhat.com>
 <20120712074200.GA12931@aemeltch-MOBL1>
 <20120716.222018.2029110835026223294.yamato@redhat.com>
 <20120725001214.GP20029@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725001214.GP20029@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo Padovan <gustavo@padovan.org> [2012-07-24 21:12:14 -0300]:

> Hi Masatake,
> 
> * Masatake YAMATO <yamato@redhat.com> [2012-07-16 22:20:18 +0900]:
> 
> > (I resend this mail becasue I got some troubles in mail sending.
> >  Andrei, [PATCH v4 [2-8]/8] are the same as [PATCH v3 [2-8]/8]. So
> >  I send [PATCH v4 1/8] only here. If I should the rest of v4 patches,
> >  please, let me know that.)
> 
> Please keep this kind of information after the --- line, so git am
> automatically skip this when applying, otherwise I have to edit the commit
> message by hand.
> 
> > 
> > lsof command can tell the type of socket processes are using.
> > Internal lsof uses inode numbers on socket fs to resolve the type of
> > sockets. Files under /proc/net/, such as tcp, udp, unix, etc provides
> > such inode information.
> > 
> > Unfortunately bluetooth related protocols don't provide such inode
> > information. This patch series introduces /proc/net files for the protocols.
> > 
> > This patch against af_bluetooth.c provides facility to the implementation
> > of protocols. This patch extends bt_sock_list and introduces two exported
> > function bt_procfs_init, bt_procfs_cleanup.
> > 
> > The type bt_sock_list is already used in some of implementation of
> > protocols. bt_procfs_init prepare seq_operations which converts
> > protocol own bt_sock_list data to protocol own proc entry when the
> > entry is accessed.
> > 
> > What I, lsof user, need is just inode number of bluetooth
> > socket. However, people may want more information. The bt_procfs_init
> > takes a function pointer for customizing the show handler of
> > seq_operations.
> > 
> > In v4 patch, __acquires and __releases attributes are added to suppress
> > sparse warning. Suggested by Andrei Emeltchenko.
> > 
> > Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> > ---
> >  include/net/bluetooth/bluetooth.h |   10 +++
> >  net/bluetooth/af_bluetooth.c      |  138 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 148 insertions(+)
> 
> Patch has been applied to bluetooth-next, however I had to fix a minor
> issue...
> 
> > 
> > diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> > index 565d4be..ede0369 100644
> > --- a/include/net/bluetooth/bluetooth.h
> > +++ b/include/net/bluetooth/bluetooth.h
> > @@ -27,6 +27,7 @@
> >  
> >  #include <linux/poll.h>
> >  #include <net/sock.h>
> > +#include <linux/seq_file.h>
> >  
> >  #ifndef AF_BLUETOOTH
> >  #define AF_BLUETOOTH	31
> > @@ -202,6 +203,10 @@ enum {
> >  struct bt_sock_list {
> >  	struct hlist_head head;
> >  	rwlock_t          lock;
> > +#ifdef CONFIG_PROC_FS
> > +        struct file_operations   fops;
> > +        int (* custom_seq_show)(struct seq_file *, void *);
> > +#endif
> >  };
> >  
> >  int  bt_sock_register(int proto, const struct net_proto_family *ops);
> > @@ -292,6 +297,11 @@ extern void hci_sock_cleanup(void);
> >  extern int bt_sysfs_init(void);
> >  extern void bt_sysfs_cleanup(void);
> >  
> > +extern int  bt_procfs_init(struct module* module, struct net *net, const char *name,
> > +			   struct bt_sock_list* sk_list,
> > +			   int (* seq_show)(struct seq_file *, void *));
> > +extern void bt_procfs_cleanup(struct net *net, const char *name);
> > +
> >  extern struct dentry *bt_debugfs;
> >  
> >  int l2cap_init(void);
> > diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
> > index f7db579..f76cf2f 100644
> > --- a/net/bluetooth/af_bluetooth.c
> > +++ b/net/bluetooth/af_bluetooth.c
> > @@ -532,6 +532,144 @@ int bt_sock_wait_state(struct sock *sk, int state, unsigned long timeo)
> >  }
> >  EXPORT_SYMBOL(bt_sock_wait_state);
> >  
> > +#ifdef CONFIG_PROC_FS
> > +struct bt_seq_state {
> > +	struct bt_sock_list *l;
> > +};
> > +
> > +static void *bt_seq_start(struct seq_file *seq, loff_t *pos)
> > +	__acquires(seq->private->l->lock)
> > +{
> > +	struct bt_seq_state *s = seq->private;
> > +	struct bt_sock_list *l = s->l;
> > +
> > +	read_lock(&l->lock);
> > +	return seq_hlist_start_head(&l->head, *pos);
> > +}
> > +
> > +static void *bt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +	struct bt_seq_state *s = seq->private;
> > +	struct bt_sock_list *l = s->l;
> > +
> > +	return seq_hlist_next(v, &l->head, pos);
> > +}
> > +
> > +static void bt_seq_stop(struct seq_file *seq, void *v)
> > +	__releases(seq->private->l->lock)
> > +{
> > +	struct bt_seq_state *s = seq->private;
> > +	struct bt_sock_list *l = s->l;
> > +
> > +	read_unlock(&l->lock);
> > +}
> > +
> > +static int bt_seq_show(struct seq_file *seq, void *v)
> > +{
> > +	struct sock *sk;
> > +	struct bt_sock *bt;
> > +	struct bt_seq_state *s = seq->private;
> > +	struct bt_sock_list *l = s->l;
> > +	bdaddr_t src_baswapped, dst_baswapped;
> > +
> > +	if (v == SEQ_START_TOKEN) {
> > +		seq_puts(seq ,"sk               RefCnt Rmem   Wmem   User   Inode  Src Dst Parent");
> > +
> > +		if (l->custom_seq_show) {
> > +			seq_putc(seq, ' ');
> > +			l->custom_seq_show(seq, v);
> > +		}
> > +
> > +		seq_putc(seq, '\n');
> > +	} else {
> > +		sk = sk_entry(v);
> > +		bt = bt_sk(sk);
> > +		baswap(&src_baswapped, &bt->src);
> > +		baswap(&dst_baswapped, &bt->dst);
> > +
> > +		seq_printf(seq, "%pK %-6d %-6u %-6u %-6u %-6lu %pM %pM %-6lu",
> > +			   sk,
> > +			   atomic_read(&sk->sk_refcnt),
> > +			   sk_rmem_alloc_get(sk),
> > +			   sk_wmem_alloc_get(sk),
> > +			   sock_i_uid(sk),
> > +			   sock_i_ino(sk),
> > +			   &src_baswapped,
> > +			   &dst_baswapped,
> > +			   bt->parent? sock_i_ino(bt->parent): 0LU);
> > +
> > +		if (l->custom_seq_show) {
> > +			seq_putc(seq, ' ');
> > +			l->custom_seq_show(seq, v);
> > +		}
> > +
> > +		seq_putc(seq, '\n');
> > +	}
> > +	return 0;
> > +}
> > +
> > +static struct seq_operations bt_seq_ops = {
> > +	.start = bt_seq_start,
> > +	.next  = bt_seq_next,
> > +	.stop  = bt_seq_stop,
> > +	.show  = bt_seq_show,
> > +};
> > +
> > +static int bt_seq_open(struct inode *inode, struct file *file)
> > +{
> > +	struct bt_sock_list *sk_list;
> > +	struct bt_seq_state *s;
> > +
> > +	sk_list = PDE(inode)->data;
> > +	s = __seq_open_private(file, &bt_seq_ops,
> > +			       sizeof(struct bt_seq_state));
> > +	if (s == NULL)
> > +		return -ENOMEM;
> > +
> > +	s->l = sk_list;
> > +	return 0;
> > +}
> > +
> > +int bt_procfs_init(struct module* module, struct net *net, const char *name, struct bt_sock_list* sk_list,
> > +		   int (* seq_show)(struct seq_file *, void *))
> 
> ... the identation here is a bit wrong, I fixed it. Thanks for doing this
> work.

I reverted this patch, it is not building.

	Gustavo

