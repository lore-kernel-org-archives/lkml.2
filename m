Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0IMQKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:10:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0IMQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:10:12 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=C1JT1793vIUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IqdN8cW2qiXuo5HI3TQA:9 a=-Cw2643ObA19phZm9qoA:7 a=DNb1-ZeAklAFxyQv0iGgdJbeVCcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace-cmd: Use lseek64 and off64_t in
 tracecmd_append_cpu_data().
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: mrubin@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <1284168258-24287-1-git-send-email-dhsharp@google.com>
References: <1284168258-24287-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 12:10:10 -0400
Message-ID: <1284394210.17152.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 2010-09-10 at 18:24 -0700, David Sharp wrote:
> lseek64 returns 64-bit, but was being truncated to int. Large offsets would
> cause the subsequent error checking to fail spuriously, leaving behind a bad
> trace.dat and a collection of trace.dat.cpuX files.


Could you resend with your SoB.

Thanks!

-- Steve

> ---
>  trace-output.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/trace-output.c b/trace-output.c
> index 89b3954..0730a1e 100644
> --- a/trace-output.c
> +++ b/trace-output.c
> @@ -705,9 +705,9 @@ out_free:
>  int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  			     int cpus, char * const *cpu_data_files)
>  {
> -	unsigned long long *offsets = NULL;
> +	off64_t *offsets = NULL;
>  	unsigned long long *sizes = NULL;
> -	unsigned long long offset;
> +	off64_t offset;
>  	unsigned long long endian8;
>  	off64_t check_size;
>  	char *file;
> @@ -733,7 +733,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  	if (!sizes)
>  		goto out_free;
>  
> -	offset = lseek(handle->fd, 0, SEEK_CUR);
> +	offset = lseek64(handle->fd, 0, SEEK_CUR);
>  
>  	/* hold any extra data for data */
>  	offset += cpus * (16);
> @@ -761,8 +761,8 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
>  
>  	for (i = 0; i < cpus; i++) {
>  		fprintf(stderr, "offset=%llx\n", offsets[i]);
> -		ret = lseek64(handle->fd, offsets[i], SEEK_SET);
> -		if (ret < 0) {
> +		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
> +		if (offset == (off64_t)-1) {
>  			warning("could not seek to %lld\n", offsets[i]);
>  			goto out_free;
>  		}


