Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0JANi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:38:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:58321 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab0JANiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:38:54 -0400
Date: Fri, 1 Oct 2010 08:38:47 -0500
From: Robin Holt <holt@sgi.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Robin Holt <holt@sgi.com>, David Miller <davem@davemloft.net>,
        dipankar@in.ibm.com, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        den@openvz.org, mingo@elte.hu, mszeredi@suse.cz, cmm@us.ibm.com,
        npiggin@kernel.dk, xemul@openvz.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V4] fs: allow for more than 2^31 files
Message-ID: <20101001133847.GO14068@sgi.com>
References: <20100923121704.GR14064@sgi.com>
 <1285246384.362.3.camel@edumazet-laptop>
 <20100923141037.GA3811@in.ibm.com>
 <20100927.153639.212415479.davem@davemloft.net>
 <1285645611.10438.27.camel@edumazet-laptop>
 <20100930202612.GM14068@sgi.com>
 <1285879545.2705.4.camel@edumazet-laptop>
 <20101001043413.GN14068@sgi.com>
 <1285909434.2705.35.camel@edumazet-laptop>
 <1285910958.2705.56.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285910958.2705.56.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Reviewed-by: Robin Holt <holt@sgi.com>
Tested-by: Robin Holt <holt@sgi.com>

I don't mean to flood this with my name, merely that I do find this
patch acceptable, worthy, and have tested it.  Feel free to lop off any
of these lines that are offensive.

Robin

On Fri, Oct 01, 2010 at 07:29:18AM +0200, Eric Dumazet wrote:
> Le vendredi 01 octobre 2010 à 07:03 +0200, Eric Dumazet a écrit :
> > Le jeudi 30 septembre 2010 à 23:34 -0500, Robin Holt a écrit :
> > 
> > > The proc_handler used to be proc_nr_files() which would call
> > > get_nr_files() and deposit the result in files_stat.nr_files then cascade
> > > to proc_dointvec() which would dump the 3 values.  Now it will dump the
> > > three values, but not update the middle (nr_files) value first.
> > > 
> > 
> > Ah I get it now, thanks !
> > 
> > I'll send a V4 shortly.
> > 
> > 
> 
> In this v4, I call proc_nr_files() again, and proc_nr_files() calls
> proc_doulongvec_minmax() instead of proc_dointvec()
> 
> Added the "cat /proc/sys/fs/file-nr" in Changelog
> 
> Thanks again Robin
> 
> [PATCH V3] fs: allow for more than 2^31 files
> 
> Robin Holt tried to boot a 16TB system and found af_unix was overflowing
> a 32bit value :
> 
> <quote>
> 
> We were seeing a failure which prevented boot.  The kernel was incapable
> of creating either a named pipe or unix domain socket.  This comes down
> to a common kernel function called unix_create1() which does:
> 
>         atomic_inc(&unix_nr_socks);
>         if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
>                 goto out;
> 
> The function get_max_files() is a simple return of files_stat.max_files.
> files_stat.max_files is a signed integer and is computed in
> fs/file_table.c's files_init().
> 
>         n = (mempages * (PAGE_SIZE / 1024)) / 10;
>         files_stat.max_files = n;
> 
> In our case, mempages (total_ram_pages) is approx 3,758,096,384
> (0xe0000000).  That leaves max_files at approximately 1,503,238,553.
> This causes 2 * get_max_files() to integer overflow.
> 
> </quote>
> 
> Fix is to let /proc/sys/fs/file-nr & /proc/sys/fs/file-max use long
> integers, and change af_unix to use an atomic_long_t instead of
> atomic_t.
> 
> get_max_files() is changed to return an unsigned long.
> get_nr_files() is changed to return a long.
> 
> unix_nr_socks is changed from atomic_t to atomic_long_t, while not
> strictly needed to address Robin problem.
>  
> Before patch (on a 64bit kernel) :
> # echo 2147483648 >/proc/sys/fs/file-max
> # cat /proc/sys/fs/file-max
> -18446744071562067968
> 
> After patch:
> # echo 2147483648 >/proc/sys/fs/file-max
> # cat /proc/sys/fs/file-max
> 2147483648
> # cat /proc/sys/fs/file-nr
> 704	0	2147483648
> 
> 
> Reported-by: Robin Holt <holt@sgi.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  fs/file_table.c    |   17 +++++++----------
>  include/linux/fs.h |    8 ++++----
>  kernel/sysctl.c    |    6 +++---
>  net/unix/af_unix.c |   14 +++++++-------
>  4 files changed, 21 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index a04bdd8..c3dee38 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -60,7 +60,7 @@ static inline void file_free(struct file *f)
>  /*
>   * Return the total number of open files in the system
>   */
> -static int get_nr_files(void)
> +static long get_nr_files(void)
>  {
>  	return percpu_counter_read_positive(&nr_files);
>  }
> @@ -68,7 +68,7 @@ static int get_nr_files(void)
>  /*
>   * Return the maximum number of open files in the system
>   */
> -int get_max_files(void)
> +unsigned long get_max_files(void)
>  {
>  	return files_stat.max_files;
>  }
> @@ -82,7 +82,7 @@ int proc_nr_files(ctl_table *table, int write,
>                       void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
>  	files_stat.nr_files = get_nr_files();
> -	return proc_dointvec(table, write, buffer, lenp, ppos);
> +	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  #else
>  int proc_nr_files(ctl_table *table, int write,
> @@ -105,7 +105,7 @@ int proc_nr_files(ctl_table *table, int write,
>  struct file *get_empty_filp(void)
>  {
>  	const struct cred *cred = current_cred();
> -	static int old_max;
> +	static long old_max;
>  	struct file * f;
>  
>  	/*
> @@ -140,8 +140,7 @@ struct file *get_empty_filp(void)
>  over:
>  	/* Ran out of filps - report that */
>  	if (get_nr_files() > old_max) {
> -		printk(KERN_INFO "VFS: file-max limit %d reached\n",
> -					get_max_files());
> +		pr_info("VFS: file-max limit %lu reached\n", get_max_files());
>  		old_max = get_nr_files();
>  	}
>  	goto fail;
> @@ -487,7 +486,7 @@ retry:
>  
>  void __init files_init(unsigned long mempages)
>  { 
> -	int n; 
> +	unsigned long n;
>  
>  	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
>  			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
> @@ -498,9 +497,7 @@ void __init files_init(unsigned long mempages)
>  	 */ 
>  
>  	n = (mempages * (PAGE_SIZE / 1024)) / 10;
> -	files_stat.max_files = n; 
> -	if (files_stat.max_files < NR_FILE)
> -		files_stat.max_files = NR_FILE;
> +	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
>  	files_defer_init();
>  	lg_lock_init(files_lglock);
>  	percpu_counter_init(&nr_files, 0);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 63d069b..8c06590 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -34,9 +34,9 @@
>  
>  /* And dynamically-tunable limits and defaults: */
>  struct files_stat_struct {
> -	int nr_files;		/* read only */
> -	int nr_free_files;	/* read only */
> -	int max_files;		/* tunable */
> +	unsigned long nr_files;		/* read only */
> +	unsigned long nr_free_files;	/* read only */
> +	unsigned long max_files;		/* tunable */
>  };
>  
>  struct inodes_stat_t {
> @@ -404,7 +404,7 @@ extern void __init inode_init_early(void);
>  extern void __init files_init(unsigned long);
>  
>  extern struct files_stat_struct files_stat;
> -extern int get_max_files(void);
> +extern unsigned long get_max_files(void);
>  extern int sysctl_nr_open;
>  extern struct inodes_stat_t inodes_stat;
>  extern int leases_enable, lease_break_time;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f88552c..f789a0a 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1352,16 +1352,16 @@ static struct ctl_table fs_table[] = {
>  	{
>  		.procname	= "file-nr",
>  		.data		= &files_stat,
> -		.maxlen		= 3*sizeof(int),
> +		.maxlen		= sizeof(files_stat),
>  		.mode		= 0444,
>  		.proc_handler	= proc_nr_files,
>  	},
>  	{
>  		.procname	= "file-max",
>  		.data		= &files_stat.max_files,
> -		.maxlen		= sizeof(int),
> +		.maxlen		= sizeof(files_stat.max_files),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_doulongvec_minmax,
>  	},
>  	{
>  		.procname	= "nr_open",
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 0b39b24..3e1d7d1 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -117,7 +117,7 @@
>  
>  static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
>  static DEFINE_SPINLOCK(unix_table_lock);
> -static atomic_t unix_nr_socks = ATOMIC_INIT(0);
> +static atomic_long_t unix_nr_socks;
>  
>  #define unix_sockets_unbound	(&unix_socket_table[UNIX_HASH_SIZE])
>  
> @@ -360,13 +360,13 @@ static void unix_sock_destructor(struct sock *sk)
>  	if (u->addr)
>  		unix_release_addr(u->addr);
>  
> -	atomic_dec(&unix_nr_socks);
> +	atomic_long_dec(&unix_nr_socks);
>  	local_bh_disable();
>  	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>  	local_bh_enable();
>  #ifdef UNIX_REFCNT_DEBUG
> -	printk(KERN_DEBUG "UNIX %p is destroyed, %d are still alive.\n", sk,
> -		atomic_read(&unix_nr_socks));
> +	printk(KERN_DEBUG "UNIX %p is destroyed, %ld are still alive.\n", sk,
> +		atomic_long_read(&unix_nr_socks));
>  #endif
>  }
>  
> @@ -606,8 +606,8 @@ static struct sock *unix_create1(struct net *net, struct socket *sock)
>  	struct sock *sk = NULL;
>  	struct unix_sock *u;
>  
> -	atomic_inc(&unix_nr_socks);
> -	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
> +	atomic_long_inc(&unix_nr_socks);
> +	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
>  		goto out;
>  
>  	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto);
> @@ -632,7 +632,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock)
>  	unix_insert_socket(unix_sockets_unbound, sk);
>  out:
>  	if (sk == NULL)
> -		atomic_dec(&unix_nr_socks);
> +		atomic_long_dec(&unix_nr_socks);
>  	else {
>  		local_bh_disable();
>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
