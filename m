Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0GVHVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab0GVHU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:20:58 -0400
Date: Thu, 22 Jul 2010 10:20:44 +0300
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, paulus@samba.org
Subject: perf annotate segfaults when source code has goto label that looks
 like hex number
Message-ID: <20100722072044.GD27177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The script below demonstrate this. The problem is in
hist_entry__parse_objdump_line():

        if (*tmp) {
                /*
                 * Parse hexa addresses followed by ':'
                 */
                line_ip = strtoull(tmp, &tmp2, 16);
                if (*tmp2 != ':' || tmp == tmp2)
                        line_ip = -1;
        }
 
strtoull() returns valid number when it gets line with label and following
test passes too. I can't think of a way to unambiguously distinguish between
label and valid rip. May be running objdump with --prefix-addresses will
help, but it may make other thing unambiguous.

=== script ===
cat > test.c << EOF
int main(int argc, char **argv)
{
	int i;

	while(1) {
		i++;
		if (i == 10000000)
			goto add;
	}
add:
	return 0;
}
EOF

gcc -g test.c
perf record ./a.out
perf annotate
--
			Gleb.
