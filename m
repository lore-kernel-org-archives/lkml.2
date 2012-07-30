Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2G3WM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:12:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17246 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab2G3WMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:12:24 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=5qkZj-nraFkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=k1IkWSz2LhNILjD5PckA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343686341.27983.15.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 4/6] ftrace: Allow stealing pages from pipe buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@amd64.org>, "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 30 Jul 2012 18:12:21 -0400
In-Reply-To: <20120724023738.6600.59837.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120724023738.6600.59837.stgit@ltc189.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 11:37 +0900, Yoshihiro YUNOMAE wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Use generic steal operation on pipe buffer to allow stealing
> ring buffer's read page from pipe buffer.
> 
> Note that this could reduce the performance of splice on the
> splice_write side operation without affinity setting.
> Since the ring buffer's read pages are allocated on the
> tracing-node, but the splice user does not always execute
> splice write side operation on the same node. In this case,
> the page will be accessed from the another node.
> Thus, it is strongly recommended to assign the splicing
> thread to corresponding node.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
> 
>  kernel/trace/trace.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a120f98..ae01930 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4194,12 +4194,6 @@ static void buffer_pipe_buf_release(struct pipe_inode_info *pipe,
>  	buf->private = 0;
>  }
>  
> -static int buffer_pipe_buf_steal(struct pipe_inode_info *pipe,
> -				 struct pipe_buffer *buf)
> -{
> -	return 1;
> -}
> -
>  static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
>  				struct pipe_buffer *buf)
>  {
> @@ -4215,7 +4209,7 @@ static const struct pipe_buf_operations buffer_pipe_buf_ops = {
>  	.unmap			= generic_pipe_buf_unmap,
>  	.confirm		= generic_pipe_buf_confirm,
>  	.release		= buffer_pipe_buf_release,
> -	.steal			= buffer_pipe_buf_steal,
> +	.steal			= generic_pipe_buf_steal,
>  	.get			= buffer_pipe_buf_get,
>  };
>  
> 


