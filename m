Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2LHC6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:58:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17730 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496Ab2LHC6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:58:43 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=9v1Bx27WI7kA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=OuX3rJNq5KYA:10 a=uvKdube58NaULWC80IkA:9 a=CjuIK1q_8ugA:10 a=SuviVTiDWjT2EweP:21 a=w0a1kxgnPOSfg03e:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 7 Dec 2012 21:58:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@osdl.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Debugging: Keep track of page owners
Message-ID: <20121208025842.GC31591@home.goodmis.org>
References: <20121207212417.FAD8DAED@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207212417.FAD8DAED@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 04:24:17PM -0500, Dave Hansen wrote:
> 
> diff -puN /dev/null Documentation/page_owner.c

Can we stop putting code into Documentation? We have tools, samples and
usr directories. I'm sure this could fit into one of them.

-- Steve

> --- /dev/null	2012-06-13 15:09:09.708529931 -0400
> +++ linux-2.6.git-dave/Documentation/page_owner.c	2012-12-07 16:22:43.872270758 -0500
> @@ -0,0 +1,141 @@
> +/*
> + * User-space helper to sort the output of /sys/kernel/debug/page_owner
> + *
> + * Example use:
> + * cat /sys/kernel/debug/page_owner > page_owner_full.txt
> + * grep -v ^PFN page_owner_full.txt > page_owner.txt
> + * ./sort page_owner.txt sorted_page_owner.txt
> +*/
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <string.h>
> +
> +struct block_list {
> +	char *txt;
> +	int len;
> +	int num;
> +};
> +
> +
> +static struct block_list *list;
> +static int list_size;
> +static int max_size;
> +
> +struct block_list *block_head;
> +
> +int read_block(char *buf, FILE *fin)
> +{
> +	int ret = 0;
> +	int hit = 0;
> +	char *curr = buf;
> +
> +	for (;;) {
> +		*curr = getc(fin);
> +		if (*curr == EOF) return -1;
> +
> +		ret++;
> +		if (*curr == '\n' && hit == 1)
> +			return ret - 1;
> +		else if (*curr == '\n')
> +			hit = 1;
> +		else
> +			hit = 0;
> +		curr++;
> +	}
> +}
> +
> +static int compare_txt(struct block_list *l1, struct block_list *l2)
> +{
> +	return strcmp(l1->txt, l2->txt);
> +}
> +
> +static int compare_num(struct block_list *l1, struct block_list *l2)
> +{
> +	return l2->num - l1->num;
> +}
> +
> +static void add_list(char *buf, int len)
> +{
> +	if (list_size != 0 &&
> +	    len == list[list_size-1].len &&
> +	    memcmp(buf, list[list_size-1].txt, len) == 0) {
> +		list[list_size-1].num++;
> +		return;
> +	}
> +	if (list_size == max_size) {
> +		printf("max_size too small??\n");
> +		exit(1);
> +	}
> +	list[list_size].txt = malloc(len+1);
> +	list[list_size].len = len;
> +	list[list_size].num = 1;
> +	memcpy(list[list_size].txt, buf, len);
> +	list[list_size].txt[len] = 0;
> +	list_size++;
> +	if (list_size % 1000 == 0) {
> +		printf("loaded %d\r", list_size);
> +		fflush(stdout);
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	FILE *fin, *fout;
> +	char buf[1024];
> +	int ret, i, count;
> +	struct block_list *list2;
> +	struct stat st;
> +
> +	fin = fopen(argv[1], "r");
> +	fout = fopen(argv[2], "w");
> +	if (!fin || !fout) {
> +		printf("Usage: ./program <input> <output>\n");
> +		perror("open: ");
> +		exit(2);
> +	}
> +
> +	fstat(fileno(fin), &st);
> +	max_size = st.st_size / 100; /* hack ... */
> +
> +	list = malloc(max_size * sizeof(*list));
> +
> +	for(;;) {
> +		ret = read_block(buf, fin);
> +		if (ret < 0)
> +			break;
> +
> +		buf[ret] = '\0';
> +		add_list(buf, ret);
> +	}
> +
> +	printf("loaded %d\n", list_size);
> +
> +	printf("sorting ....\n");
> +
> +	qsort(list, list_size, sizeof(list[0]), compare_txt);
> +
> +	list2 = malloc(sizeof(*list) * list_size);
> +
> +	printf("culling\n");
> +
> +	for (i=count=0;i<list_size;i++) {
> +		if (count == 0 ||
> +		    strcmp(list2[count-1].txt, list[i].txt) != 0) {
> +			list2[count++] = list[i];
> +		} else {
> +			list2[count-1].num += list[i].num;
> +		}
> +	}
> +
> +	qsort(list2, count, sizeof(list[0]), compare_num);
> +
> +	for (i=0;i<count;i++) {
> +		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
> +	}
> +	return 0;
> +}
