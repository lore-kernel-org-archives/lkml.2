Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1GMUjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:39:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1GMUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:39:02 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=NyiLX209gCUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0uzQrzYkSFt1cSDf7EEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <30671.1310554369@neuling.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
	 <29926.1310553581@neuling.org>  <30671.1310554369@neuling.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 13 Jul 2011 16:38:56 -0400
Message-ID: <1310589536.3931.25.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 20:52 +1000, Michael Neuling wrote:

> Actually, here's an updated patch to fix these..
> 
> FYI perf record/annotate/report works fine on my powerpc box here with
> this.  I don't have modules handy so I've not tested that aspect.

Sure it worked for you...


> -static unsigned long get_size(const char *file)
> -{
> -	unsigned long long size = 0;
> -	int fd;
> -
> -	fd = open(file, O_RDONLY);
> -	if (fd < 0)
> -		die("Can't read '%s'", file);
> -	size = get_size_fd(fd);
>  	close(fd);
>  
> -	return size;
> +	/* ugh, handle big-endian hdr_size == 4 */
> +	sizep = (char*)&size;
> +	if (bigendian())
> +		sizep += sizeof(u64) - hdr_sz;
> +
> +	if (pwrite(output_fd, &size, hdr_sz, hdr_pos) < 0)

s/&size/sizep/

-- Steve

> +		die("writing to %s", output_file);
>  }


