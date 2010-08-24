Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0HXHHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:07:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0HXHHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rBShRVF5HBHR6pkUvuCWMxtyN2qdEnFMrEL1eENNW/79GjmCYO9LggcRXAAygPMH60
         +Xk2waZ8Rq85H6mQ55J0hcjZwSXNGvSmvi7rGFtCNKbZQU230QPA0qGo/T/9pdSOwPzT
         ugJhtmyPlzFxcA49u6a6GwS9OCwBXw8QkNR2U=
MIME-Version: 1.0
Date: Tue, 24 Aug 2010 15:07:33 +0800
Message-ID: <AANLkTi=9Cn=R8SPMCRp5z+gEjXbaBHeb-AaOtRbuwwcn@mail.gmail.com>
Subject: [PATCH] perf: fix core dump
From: jovi zhang <bookjovi@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu, acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf invoke symbol__init function twice when we input command "perf
kmem/sched record ls", then it will core dump when symbol__exit
invoked.
So give a flag to make symbol__init can be invoked once.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
tools/perf/util/symbol.c |    9 +++++++++
1 files changed, 9 insertions(+), 0 deletions(-)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..aded121 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -43,6 +43,8 @@ struct symbol_conf symbol_conf = {
       .try_vmlinux_path = true,
};

+static bool symbol_initizated;
+
int dso__name_len(const struct dso *self)
{
       if (verbose)
@@ -2268,6 +2270,11 @@ static int setup_list(struct strlist **list,
const char *list_str,

int symbol__init(void)
{
+       if (symbol_initizated == true)
+               return 0;
+       else
+               symbol_initizated = true;
+
       elf_version(EV_CURRENT);
       if (symbol_conf.sort_by_name)
               symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
@@ -2304,6 +2311,8 @@ out_free_comm_list:

void symbol__exit(void)
{
+       if (symbol_initizated == false)
+               return;
       strlist__delete(symbol_conf.sym_list);
       strlist__delete(symbol_conf.dso_list);
       strlist__delete(symbol_conf.comm_list);
