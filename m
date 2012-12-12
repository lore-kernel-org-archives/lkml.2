Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2LLKB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:01:57 -0500
Received: from intranet.asianux.com ([58.214.24.6]:51500 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2LLKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:01:55 -0500
X-Spam-Score: -100.8
Message-ID: <50C85644.7020203@asianux.com>
Date: Wed, 12 Dec 2012 18:02:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: omar.ramirez@ti.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: pr_err and pr_debug
 for uninitialized buffer (name buf not initialized).
References: <50C852E9.5020107@asianux.com>
In-Reply-To: <50C852E9.5020107@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月12日 17:48, Chen Gang 写道:
> Hello Omar Ramirez Luna:
> 
>   in drivers/staging/tidspbridge/core/io_sm.c:
>     it is for function dump_dsp_stack.
>     "char name[256]" is not initialized.  (line 1898)
>     name is as out buf for node_find_addr (line 2021..2024, 2066..2071, 2098..2103)
>       if node_find_addr fails, pr_err may cause issue (name may not be initialized)

  oh sorry, pr_err no issue (it is my fault).

> 
>   in drivers/staging/tidspbridge/rmgr/node.c:
>     function node_find_addr can be called by dump_dsp_stack.
>     param sym_name is as out buf which may be not initialized.
>     so pr_debug may cause issue (print sym_name).
> 
>   in drivers/staging/tidspbridge/rmgr/nldr.c:
>     function nldr_find_addr can be called by node_find_addr 
>     param sym_name is as out buf which may be not initialized.
>     so pr_debug may cause issue (print sym_name).
> 

  but they are still have issue. 
  I find by code review, please help check whether this suggestion is valid.

  thanks.

>   please help checking, thanks.
> 
> gchen.
> 
> 
> in drivers/staging/tidspbridge/rmgr/nldr.c:
> 
> 1798 int nldr_find_addr(struct nldr_nodeobject *nldr_node, u32 sym_addr,
> 1799                         u32 offset_range, void *offset_output, char *sym_name)
> 1800 {
> 1801         int status = 0;
> 1802         bool status1 = false;
> 1803         s32 i = 0;
> 1804         struct lib_node root = { NULL, 0, NULL };
> 1805         pr_debug("%s(0x%x, 0x%x, 0x%x, 0x%x,  %s)\n", __func__, (u32) nldr_node,
> 1806                         sym_addr, offset_range, (u32) offset_output, sym_name);
> 1807 
>  ...
> 
> 
> in drivers/staging/tidspbridge/rmgr/node.c:
> 
> 3009 int node_find_addr(struct node_mgr *node_mgr, u32 sym_addr,
> 3010                 u32 offset_range, void *sym_addr_output, char *sym_name)
> 3011 {
> 3012         struct node_object *node_obj;
> 3013         int status = -ENOENT;
> 3014 
> 3015         pr_debug("%s(0x%x, 0x%x, 0x%x, 0x%x,  %s)\n", __func__,
> 3016                         (unsigned int) node_mgr,
> 3017                         sym_addr, offset_range,
> 3018                         (unsigned int) sym_addr_output, sym_name);
> 3019 
> 3020         list_for_each_entry(node_obj, &node_mgr->node_list, list_elem) {
> 3021                 status = nldr_find_addr(node_obj->nldr_node_obj, sym_addr,
> 3022                         offset_range, sym_addr_output, sym_name);
> 3023                 if (!status)
> 3024                         break;
> 3025         }
> 3026 
> 3027         return status;
> 3028 }
> 
> 
> 
> 
> in drivers/staging/tidspbridge/core/io_sm.c:
> 
> 1892 int dump_dsp_stack(struct bridge_dev_context *bridge_context)
> 1893 {
> 1894         int status = 0;
> 1895         struct cod_manager *code_mgr;
> 1896         struct node_mgr *node_mgr;
> 1897         u32 trace_begin;
> 1898         char name[256];
> 1899         struct {
> 1900                 u32 head[2];
> 1901                 u32 size;
> 1902         } mmu_fault_dbg_info;
> 1903         u32 *buffer;
> 1904         u32 *buffer_beg;
> 1905         u32 *buffer_end;
> 1906         u32 exc_type;
> 1907         u32 dyn_ext_base;
> 1908         u32 i;
> 1909         u32 offset_output;
> 1910         u32 total_size;
> 1911         u32 poll_cnt;
> 1912         const char *dsp_regs[] = {"EFR", "IERR", "ITSR", "NTSR",
> 1913                                 "IRP", "NRP", "AMR", "SSR",
> 1914                                 "ILC", "RILC", "IER", "CSR"};
> 1915         const char *exec_ctxt[] = {"Task", "SWI", "HWI", "Unknown"};
> 1916         struct bridge_drv_interface *intf_fxns;
> 1917         struct dev_object *dev_object = bridge_context->dev_obj;
> 1918 
> 1919         status = dev_get_cod_mgr(dev_object, &code_mgr);
> 1920         if (!code_mgr) {
> 1921                 pr_debug("%s: Failed on dev_get_cod_mgr.\n", __func__);
> 1922                 status = -EFAULT;
> 1923         }
> 1924 
> 1925         if (!status) {
> 1926                 status = dev_get_node_manager(dev_object, &node_mgr);
> 1927                 if (!node_mgr) {
> 1928                         pr_debug("%s: Failed on dev_get_node_manager.\n",
> 1929                                                                 __func__);
> 1930                         status = -EFAULT;
> 1931                 }
> 1932         }
> 1933 
> 1934         if (!status) {
> 1935                 /* Look for SYS_PUTCBEG/SYS_PUTCEND: */
> 1936                 status =
> 1937                         cod_get_sym_value(code_mgr, COD_TRACEBEG, &trace_begin);
> 1938                 pr_debug("%s: trace_begin Value 0x%x\n",
> 1939                         __func__, trace_begin);
> 1940                 if (status)
> 1941                         pr_debug("%s: Failed on cod_get_sym_value.\n",
> 1942                                                                 __func__);
> 1943         }
> 1944         if (!status)
> 1945                 status = dev_get_intf_fxns(dev_object, &intf_fxns);
> 1946         /*
> 1947          * Check for the "magic number" in the trace buffer.  If it has
> 1948          * yet to appear then poll the trace buffer to wait for it.  Its
> 1949          * appearance signals that the DSP has finished dumping its state.
> 1950          */
> 1951         mmu_fault_dbg_info.head[0] = 0;
> 1952         mmu_fault_dbg_info.head[1] = 0;
> 1953         if (!status) {
> 1954                 poll_cnt = 0;
> 1955                 while ((mmu_fault_dbg_info.head[0] != MMU_FAULT_HEAD1 ||
> 1956                         mmu_fault_dbg_info.head[1] != MMU_FAULT_HEAD2) &&
> 1957                         poll_cnt < POLL_MAX) {
> 1958 
> 1959                         /* Read DSP dump size from the DSP trace buffer... */
> 1960                         status = (*intf_fxns->brd_read)(bridge_context,
> 1961                                 (u8 *)&mmu_fault_dbg_info, (u32)trace_begin,
> 1962                                 sizeof(mmu_fault_dbg_info), 0);
> 1963 
> 1964                         if (status)
> 1965                                 break;
> 1966 
> 1967                         poll_cnt++;
> 1968                 }
> 1969 
> 1970                 if (mmu_fault_dbg_info.head[0] != MMU_FAULT_HEAD1 &&
> 1971                         mmu_fault_dbg_info.head[1] != MMU_FAULT_HEAD2) {
> 1972                         status = -ETIME;
> 1973                         pr_err("%s:No DSP MMU-Fault information available.\n",
> 1974                                                         __func__);
> 1975                 }
> 1976         }
> 1977 
> 1978         if (!status) {
> 1979                 total_size = mmu_fault_dbg_info.size;
> 1980                 /* Limit the size in case DSP went crazy */
> 1981                 if (total_size > MAX_MMU_DBGBUFF)
> 1982                         total_size = MAX_MMU_DBGBUFF;
> 1983 
> 1984                 buffer = kzalloc(total_size, GFP_ATOMIC);
> 1985                 if (!buffer) {
> 1986                         status = -ENOMEM;
> 1987                         pr_debug("%s: Failed to "
> 1988                                 "allocate stack dump buffer.\n", __func__);
> 1989                         goto func_end;
> 1990                 }
> 1991 
> 1992                 buffer_beg = buffer;
> 1993                 buffer_end =  buffer + total_size / 4;
> 1994 
> 1994 
> 1995                 /* Read bytes from the DSP trace buffer... */
> 1996                 status = (*intf_fxns->brd_read)(bridge_context,
> 1997                                 (u8 *)buffer, (u32)trace_begin,
> 1998                                 total_size, 0);
> 1999                 if (status) {
> 2000                         pr_debug("%s: Failed to Read Trace Buffer.\n",
> 2001                                                                 __func__);
> 2002                         goto func_end;
> 2003                 }
> 2004 
> 2005                 pr_err("\nAproximate Crash Position:\n"
> 2006                         "--------------------------\n");
> 2007 
> 2008                 exc_type = buffer[3];
> 2009                 if (!exc_type)
> 2010                         i = buffer[79];         /* IRP */
> 2011                 else
> 2012                         i = buffer[80];         /* NRP */
> 2013 
> 2014                 status =
> 2015                     cod_get_sym_value(code_mgr, DYNEXTBASE, &dyn_ext_base);
> 2016                 if (status) {
> 2017                         status = -EFAULT;
> 2018                         goto func_end;
> 2019                 }
> 2020 
> 2021                 if ((i > dyn_ext_base) && (node_find_addr(node_mgr, i,
> 2022                         0x1000, &offset_output, name) == 0))
> 2023                         pr_err("0x%-8x [\"%s\" + 0x%x]\n", i, name,
> 2024                                                         i - offset_output);
> 2025                 else
> 2026                         pr_err("0x%-8x [Unable to match to a symbol.]\n", i);
> 2027 
> 2028                 buffer += 4;
> 2029 
> 2030                 pr_err("\nExecution Info:\n"
> 2031                         "---------------\n");
> 2032 
> 2033                 if (*buffer < ARRAY_SIZE(exec_ctxt)) {
> 2034                         pr_err("Execution context \t%s\n",
> 2035                                 exec_ctxt[*buffer++]);
> 2036                 } else {
> 2037                         pr_err("Execution context corrupt\n");
> 2038                         kfree(buffer_beg);
> 2039                         return -EFAULT;
> 2040                 }
> 2041                 pr_err("Task Handle\t\t0x%x\n", *buffer++);
> 2042                 pr_err("Stack Pointer\t\t0x%x\n", *buffer++);
> 2043                 pr_err("Stack Top\t\t0x%x\n", *buffer++);
> 2044                 pr_err("Stack Bottom\t\t0x%x\n", *buffer++);
> 2045                 pr_err("Stack Size\t\t0x%x\n", *buffer++);
> 2046                 pr_err("Stack Size In Use\t0x%x\n", *buffer++);
> 2047 
> 2048                 pr_err("\nCPU Registers\n"
> 2049                         "---------------\n");
> 2050 
> 2051                 for (i = 0; i < 32; i++) {
> 2052                         if (i == 4 || i == 6 || i == 8)
> 2053                                 pr_err("A%d 0x%-8x [Function Argument %d]\n",
> 2054                                                         i, *buffer++, i-3);
> 2055                         else if (i == 15)
> 2056                                 pr_err("A15 0x%-8x [Frame Pointer]\n",
> 2057                                                                 *buffer++);
> 2058                         else
> 2059                                 pr_err("A%d 0x%x\n", i, *buffer++);
> 2060                 }
> 2061 
> 2062                 pr_err("\nB0 0x%x\n", *buffer++);
> 2063                 pr_err("B1 0x%x\n", *buffer++);
> 2064                 pr_err("B2 0x%x\n", *buffer++);
> 2065 
> 2066                 if ((*buffer > dyn_ext_base) && (node_find_addr(node_mgr,
> 2067                         *buffer, 0x1000, &offset_output, name) == 0))
> 2068 
> 2069                         pr_err("B3 0x%-8x [Function Return Pointer:"
> 2070                                 " \"%s\" + 0x%x]\n", *buffer, name,
> 2071                                 *buffer - offset_output);
> 2072                 else
> 2073                         pr_err("B3 0x%-8x [Function Return Pointer:"
> 2074                                 "Unable to match to a symbol.]\n", *buffer);
> 2075 
> 2076                 buffer++;
> 2077 
> 2078                 for (i = 4; i < 32; i++) {
> 2079                         if (i == 4 || i == 6 || i == 8)
> 2080                                 pr_err("B%d 0x%-8x [Function Argument %d]\n",
> 2081                                                         i, *buffer++, i-2);
> 2082                         else if (i == 14)
> 2083                                 pr_err("B14 0x%-8x [Data Page Pointer]\n",
> 2084                                                                 *buffer++);
> 2085                         else
> 2086                                 pr_err("B%d 0x%x\n", i, *buffer++);
> 2087                 }
> 2088 
> 2089                 pr_err("\n");
> 2090 
> 2091                 for (i = 0; i < ARRAY_SIZE(dsp_regs); i++)
> 2092                         pr_err("%s 0x%x\n", dsp_regs[i], *buffer++);
> 2093 
> 2094                 pr_err("\nStack:\n"
> 2095                         "------\n");
> 2096 
> 2097                 for (i = 0; buffer < buffer_end; i++, buffer++) {
> 2098                         if ((*buffer > dyn_ext_base) && (
> 2099                                 node_find_addr(node_mgr, *buffer , 0x600,
> 2100                                 &offset_output, name) == 0))
> 2101                                 pr_err("[%d] 0x%-8x [\"%s\" + 0x%x]\n",
> 2102                                         i, *buffer, name,
> 2103                                         *buffer - offset_output);
> 2104                         else
> 2105                                 pr_err("[%d] 0x%x\n", i, *buffer);
> 2106                 }
> 2107                 kfree(buffer_beg);
> 2108         }
> 2109 func_end:
> 2110         return status;
> 2111 }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Chen Gang

Asianux Corporation
